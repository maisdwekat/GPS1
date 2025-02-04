import Investment from '../../../../DB/models/investment.model.js';
import ActionRequest from '../../../../DB/models/ActionRequest.model.js';
import { userModel } from '../../../../DB/models/user.model.js'; 
import { sendNotification } from '../../notification/notifacation.js';
import cloudenary from "../../../Servicess/cloudenary.js";
import { projectModel } from '../../../../DB/models/project.model.js'; 
import cron from 'node-cron'; 

export const addActionRequest = async (req, res) => {
  try {
    const { investmentId } = req.params;
    const { requestType, newDetails } = req.body;
 
    const requestedBy = req.user._id;

    const investment = await Investment.findById(investmentId);
    if (!investment) {
      return res.status(404).json({ error: 'الاستثمار غير موجود.' });
    }

    
    const project = await projectModel.findById(investment.projectId);
    if (!project) {
      return res.status(404).json({ error: 'المشروع غير موجود.' });
    }

   
    const createdBy = project.createdBy;
   
 
    if (req.user._id.toString() === createdBy.toString()) {
   
      if (requestType == 'تعديل' || requestType == 'حذف') {
        receiverId = investment.investorId;
      }
    } else if  (req.user._id.toString() === investment.investorId.toString()) {
  
   
      if (requestType === 'تعديل' || requestType === 'حذف') {
        req.body.receiverId = project.createdBy;
      }
    }
    let receiverId = req.body.receiverId;
    
    console.log("receiverId after assignment: ", receiverId);

  
    if (!receiverId) {
      return res.status(400).json({ error: 'لم يتم تحديد receiverId بشكل صحيح.' });
    }

    
    if (!req.file && requestType !== 'حذف') {
      return res.status(400).json({ message: "الملف مطلوب" });
    }

    let secure_url;
    if (requestType !== 'حذف') {
      const uploadResponse = await cloudenary.uploader.upload(req.file.path, {
        folder: "user/file/",
      });
      secure_url = uploadResponse.secure_url;
    }

  
    if (newDetails) {
      if (secure_url) {
        newDetails.agreementFile = secure_url;
      }
    } else if (requestType !== 'حذف') {
      newDetails = { agreementFile: secure_url };
    }

   
    const newRequest = new ActionRequest({
      investmentId,
      requestedBy,
      requestType,
      newDetails,
      receiverId,
      status: 'قيد المراجعة',
    });

    await newRequest.save();


    const receiver = await userModel.findById(receiverId);
    if (receiver && receiver.fcmToken) {
      const message = `تم تقديم طلب ${requestType} على استثمارك بواسطة ${req.user.name}. يرجى مراجعة الطلب.`;
      await sendNotification(receiver.fcmToken, message);
    }

    res.status(201).json({ message: 'تم تقديم الطلب بنجاح.', request: newRequest });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'حدث خطأ أثناء تقديم الطلب.', details: error.message });
  }
};
















export const updateRequestStatus = async (req, res) => {
  try {
    const { requestId } = req.params;
    const { status } = req.body;

    
    const updatedRequest = await ActionRequest.findByIdAndUpdate(
      requestId,
      { status },
      { new: true }
    );

    if (!updatedRequest) {
      return res.status(404).json({ error: 'الطلب غير موجود.' });
    }

    
    const investment = await Investment.findById(updatedRequest.investmentId);
    if (!investment) {
      return res.status(404).json({ error: 'الاستثمار غير موجود.' });
    }

 
    if (status === 'مقبول') {
      if (updatedRequest.requestType === 'تعديل') {
        await Investment.findByIdAndUpdate(updatedRequest.investmentId, { $set: updatedRequest.newDetails });
      } else if (updatedRequest.requestType === 'إلغاء' || updatedRequest.requestType === 'حذف') {
        await Investment.findByIdAndDelete(updatedRequest.investmentId);
      }
    }

 
    const requester = await userModel.findById(updatedRequest.requestedBy);
   

    if (requester && requester.fcmToken) {
      const message = `تم ${status === 'مقبول' ? 'قبول' : 'رفض'} طلبك المتعلق بالاستثمار.`;
      await sendNotification(requester.fcmToken, message);
    }

    res.status(200).json({ message: `تم تحديث حالة الطلب إلى ${status}.`, request: updatedRequest });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'حدث خطأ أثناء تحديث حالة الطلب.', details: error.message });
  }
};




export const getAllActionRequests = async (req, res) => {
  try {
    const actionRequests = await ActionRequest.find()
      .populate('investmentId', 'name details')
      .populate('requestedBy', 'name email')
      .sort({ createdAt: -1 });

    if (!actionRequests.length) {
      return res.status(404).json({ message: 'لا توجد طلبات حتى الآن.' });
    }

    res.status(200).json({ requests: actionRequests });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: 'حدث خطأ أثناء جلب الطلبات.', details: error.message });
  }
};



export const checkDueDates = async (req, res) => {
  try {
    const today = new Date();
    const oneDayInMillis = 24 * 60 * 60 * 1000;
    const tomorrow = new Date(today.getTime() + oneDayInMillis);

    
    const investments = await Investment.find({
      dueDate: {
        $gte: today.toISOString(),
        $lt: tomorrow.toISOString(),
      },
    });

    for (const investment of investments) {
      const investor = await userModel.findById(investment.investorId);

      if (investor && investor.fcmToken) {
        console.log('Sending notification to token:', investor.fcmToken);

        
        const message = `استثمارك (${investment._id}) يقترب من تاريخ الاستحقاق (${investment.dueDate})`;

      
        await sendNotification(investor.fcmToken, message);
      } else {
        console.log('No FCM token for investor:', investment.investorId);
      }
    }
  } catch (error) {
    console.error('حدث خطأ أثناء التحقق من تواريخ الاستحقاق:', error.message);
  }
};