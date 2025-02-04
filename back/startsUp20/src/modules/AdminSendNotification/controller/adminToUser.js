import { userModel } from "../../../../DB/models/user.model.js";
import { sendNotification } from "../../notification/notifacation.js";
export const sendCustomNotification = async (req, res) => {
  const { message } = req.body;
  const { userId } = req.params;
  try {

    const user = await userModel.findById(userId);

    if (!user) {
      return res.status(404).json({ message: "المستخدم غير موجود." });
    }


    if (!user.fcmToken) {
      return res.status(400).json({ message: "المستخدم لا يمتلك fcmToken." });
    }


      await sendNotification(user.fcmToken, message);

      res.status(200).json({ message: "تم إرسال الإشعار بنجاح" });
    

  } catch (error) {
    res.status(500).json({ message: `خطأ: ${error.message}` });
  }
};
