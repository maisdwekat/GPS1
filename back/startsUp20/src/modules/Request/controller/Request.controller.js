
import { projectModel } from "../../../../DB/models/project.model.js";
import Request from "../../../../DB/models/Request.model.js";
import { userModel } from "../../../../DB/models/user.model.js";
import Investment from "../../../../DB/models/investment.model.js"; 
import { sendNotification } from "../../notification/notifacation.js";
import cloudenary from "../../../Servicess/cloudenary.js";

export const createRequest = async (req, res) => {
  const { investmentAmount, investmentDuration, ownershipPercentage, dueDate } = req.body;
  const investorId = req.user._id;
  const { projectId } = req.params;

  try {
  
    const project = await projectModel.findById(projectId);

    if (!project) {
      return res.status(404).json({ message: 'المشروع غير موجود' });
    }

    
    const investor = await userModel.findById(investorId);

    if (!investor || investor.role !== 'investor') {
      return res.status(404).json({ message: 'المستثمر غير موجود أو ليس لديه صلاحية' });
    }

    if (!req.file) {
      return res.status(400).json({ message: " الملف مطلوب" });
    }

    
    const { secure_url } = await cloudenary.uploader.upload(req.file.path, {
      folder: "user/file/",
    });
    req.body.agreementFile = secure_url;

    
    const newRequest = await Request.create({
      investorId,
      projectId,
      investmentAmount,
      investmentDuration,
      ownershipPercentage,
      dueDate,
      agreementFile: secure_url,
      requestStatus: 'معلق',
    });
  
    
    if (project.createdBy) {
      const creator = await userModel.findById(project.createdBy);
      
      
      if (creator && creator.fcmToken) {
        await sendNotification(
          creator.fcmToken, 
          `لديك طلب استثمار جديد من المستثمر ${investor.name}.`
        );
      } else {
        console.log('FCM Token للمستقبل غير موجود');
      }
    }

    return res.status(201).json({ request: newRequest });

  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'حدث خطأ أثناء إضافة الطلب', error: error.message });
  }
};

export const updateRequest = async (req, res) => {
  try {
    const { requestId } = req.params;
    const { requestStatus } = req.body;

    const request = await Request.findById(requestId).populate("projectId");

    if (!request) {
      return res.status(404).json({ message: 'الطلب غير موجود' });
    }

    request.requestStatus = requestStatus;
    await request.save();

    const investor = await userModel.findById(request.investorId); 
    if (!investor || !investor.fcmToken) {
      return res.status(400).json({ message: 'FCM Token غير موجود للمستثمر' });
    }

    if (requestStatus === 'موافق') {
      const newInvestment = new Investment({
        investorId: request.investorId,
        projectId: request.projectId,
        investmentAmount: request.investmentAmount,
        investmentDuration: request.investmentDuration,
        ownershipPercentage: request.ownershipPercentage,
        dueDate: request.dueDate,
        agreementFile: request.agreementFile,
      });

      await newInvestment.save();

      
      await sendNotification(
        investor.fcmToken, 
        `تمت الموافقة على طلب استثمارك في المشروع ${request.projectId.name}.`
      );
    } else if (requestStatus === 'مرفوض') {
      
      await sendNotification(
        investor.fcmToken, 
        `تم رفض طلب استثمارك في المشروع ${request.projectId.name}.`
      );
    }

    return res.status(200).json({ request });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'حدث خطأ أثناء تحديث حالة الطلب', error: error.message });
  }
};


export const getRequestsByProject = async (req, res) => {
  try {
    const { projectId } = req.params;

   
    const project = await projectModel.findById(projectId);
    if (!project) {
      return res.status(404).json({ message: 'المشروع غير موجود' });
    }

    
    const requests = await Request.find({ projectId });

    return res.status(200).json({ requests });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'حدث خطأ أثناء جلب الطلبات', error: error.message });
  }
};
