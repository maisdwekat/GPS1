import { userModel } from "../../../../DB/models/user.model.js";
import bcrypt from 'bcryptjs'
import jwt from "jsonwebtoken"
import { sendEmail } from "../../../Servicess/email.js";
import { nanoid } from "nanoid"
import cloudenary from "../../../Servicess/cloudenary.js";

export const signup = async (req, res) => {
  const { name, email, password, phoneNumber, gender,role,fcmToken} = req.body; 

  try {
      const findUser = await userModel.findOne({ email: email });

      if (findUser) {
          return res.status(400).json({ message: "هذا البريد موجود مسبقًا" });
      }

      // if (!req.file) {
      //     return res.status(400).json({ message: "الصورة مطلوبة" });
      // }

      // const { secure_url } = await cloudenary.uploader.upload(req.file.path, {
      //     folder: "user/image/",
      // });

      const saltRounds = parseInt(process.env.saltRound, 10) || 10;
      const hashedPassword = await bcrypt.hash(password, saltRounds);

      const newUser = new userModel({
          name,
          email,
          password: hashedPassword,
          phoneNumber,
          gender,
          role,
          // image: secure_url,
             fcmToken, 
             
      });

      const token = jwt.sign(
          { id: newUser._id, name },
          process.env.confirmEmailToken,
          { expiresIn: "24h" }
      );

      let message = `<!DOCTYPE html>
          <html>
          <head>
              <meta charset="utf-8">
              <meta http-equiv="x-ua-compatible" content="ie=edge">
              <title>Email Confirmation</title>
              <meta name="viewport" content="width=device-width, initial-scale=1">
              <style type="text/css">
                  a {
                      color: #1a82e2;
                  }
                  img {
                      height: auto;
                  }
              </style>
          </head>
          <body style="background-color: #e9ecef;">
              <table border="0" cellpadding="0" cellspacing="0" width="100%">
                  <tr>
                      <td align="center" bgcolor="#e9ecef">
                          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                              <tr>
                                  <td align="center" valign="top" style="padding: 36px 24px;">
                                      <a href="https://www.example.com" target="_blank" style="display: inline-block;">
                                          <img src="https://example.com/logo.png" alt="Logo" width="48" style="display: block; width: 48px;">
                                      </a>
                                  </td>
                              </tr>
                          </table>
                      </td>
                  </tr>
                  <tr>
                      <td align="center" bgcolor="#e9ecef">
                          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                              <tr>
                                  <td align="left" bgcolor="#ffffff" style="padding: 36px 24px 0;">
                                      <h1>Confirm Your Email Address</h1>
                                  </td>
                              </tr>
                          </table>
                      </td>
                  </tr>
                  <tr>
                      <td align="center" bgcolor="#e9ecef">
                          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                              <tr>
                                  <td align="left" bgcolor="#ffffff">
                                       <a href="${req.protocol}://${req.headers.host}/api/v1/auth/confirmEmail/${token}" target="_blank" style="display: inline-block; padding: 16px 36px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 16px; color: #fff; text-decoration: none; border-radius: 6px;background-color:hsl(94, 59%, 35%)">verify Email</a>
                                  </td>
                              </tr>
                          </table>
                      </td>
                  </tr>
                  <tr>
                      <td align="center" bgcolor="#e9ecef" style="padding: 24px;">
                          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                              <tr>
                                  <td align="center" bgcolor="#e9ecef" style="padding: 12px 24px; font-family: 'Source Sans Pro', Helvetica, Arial, sans-serif; font-size: 14px; line-height: 20px; color: #666;">
                                      <p style="margin: 0;">StartUp Project</p>
                                  </td>
                              </tr>
                          </table>
                      </td>
                  </tr>
              </table>
          </body>
          </html>`;

      const inf = await sendEmail(email, 'verifyEmail', message);
      if (inf.accepted.length) {
          const saveUser = await newUser.save();
          return res.status(200).json({ message: "success", saveUser });
      } else {
          return res.json('فشل انشاء الحساب');
     }

  } catch (error) {
      return res.status(500).json({ message: `error ${error}` });
  }
};





export const confirmEmail=async(req,res)=>{
    try{
const {token}=req.params;
const decoded=jwt.verify(token , process.env.confirmEmailToken)
if(!decoded){
    res.json('invalid token')
}else{
    const user=await userModel.findByIdAndUpdate({_id:decoded.id,confirmEmail:false},{confirmEmail:true})
 
}


    }catch(error){
        res.json(`error catch ${error}`)
    }
}


export const signin = async (req, res) => {
  const { email, password } = req.body; 
  try {
      const user = await userModel.findOne({ email });
      if (!user) {
          res.json('هذا البريد الإلكتروني غير مسجل');
      } else {
          if (!user.confirmEmail) {
              res.json('يُرجى الانتقال إلى بريدك الإلكتروني لتأكيد الحساب');
          } else {
              const match = await bcrypt.compare(password, user.password);
              if (!match) {
                  res.json('يرجى التأكد من صحة كلمة المرور');
              } else {
                  user.lastLogin = new Date();
                  
                 
                  await user.save();

                  const token = jwt.sign({ id: user._id, email, name: user.name, role: user.role }, process.env.TokenSignIn, { expiresIn: 60 * 60 * 24 });
                  res.status(200).json({ message: "success", token,user });
              }
          }
      }
  } catch (error) {
      res.json(`catch error ${error}`);
  }
};



export const forgetPassward=async(req,res)=>{
    const {code , email , newPassword}=req.body
    try{
        if(code==null){
            return res.json('الرجاء إدخال رمن اعادة التعيين')
        }else{
            const  hash=bcrypt.hashSync(newPassword , parseInt(process.env.saltRound))
            const user=await userModel.findOneAndUpdate({email:email , sendCode:code},{password:hash, sendCode:null})
            if(!user){
                return res.json('الرجاء التحقق من صحة الرمز')
            }
            return res.status(200).json({message:"sucsses",user})
        }
    }catch(error){
        res.json(`catch error ${error}`)
    }
  
}




export const sendCode = async (req, res) => {
  try {
    const { email } = req.body;

   
    const findUser = await userModel.findOne({ email: email });
    if (!findUser) {
      return res.status(404).json({ message: 'الرجاء تسجيل الدخول' });
    }

    
    const code = nanoid();

   
    const user = await userModel.findOneAndUpdate(
      { _id: findUser.id },
      { sendCode: code },
      { new: true }
    );

    if (!user) {
      return res.status(500).json({ message: 'فشل إرسال الرمز' });
    }

   
    const message = `
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <title>Email Confirmation</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style type="text/css">
          body, table, td, a { -ms-text-size-adjust: 100%; -webkit-text-size-adjust: 100%; }
          table, td { mso-table-rspace: 0pt; mso-table-lspace: 0pt; }
          img { -ms-interpolation-mode: bicubic; }
          a[x-apple-data-detectors] { font-family: inherit !important; font-size: inherit !important; font-weight: inherit !important; line-height: inherit !important; color: inherit !important; text-decoration: none !important; }
          div[style*="margin: 16px 0;"] { margin: 0 !important; }
          body { width: 100% !important; height: 100% !important; padding: 0 !important; margin: 0 !important; }
          table { border-collapse: collapse !important; }
          a { color: #1a82e2; }
          img { height: auto; line-height: 100%; text-decoration: none; border: 0; outline: none; }
        </style>
      </head>
      <body style="background-color: #e9ecef;">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
          <tr>
            <td align="center" bgcolor="#e9ecef">
              <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                <tr>
                  <td align="center" valign="top" style="padding:36px 24px">
                    <a href="https://www.blogdesire.com" style="display:inline-block" target="_blank">
                      <img src="https://res.cloudinary.com/dql35ano3/image/upload/v1706784409/images-removebg-preview_pnwmqz.png" alt="Logo" border="0" width="48" style="display:block;width:48px;">
                    </a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td align="center" bgcolor="#e9ecef">
              <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                <tr>
                  <td align="left" bgcolor="#ffffff" style="padding:36px 24px 0;font-family:'Source Sans Pro',Helvetica,Arial,sans-serif;border-top:3px solid #d4dadf">
                    <h1 style="margin:0;font-size:32px;font-weight:700;letter-spacing:-1px;line-height:48px">Verify Your Email Address</h1>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td align="center" bgcolor="#e9ecef">
              <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                <tr>
                  <td align="left" bgcolor="#ffffff" style="padding:24px;font-family:'Source Sans Pro',Helvetica,Arial,sans-serif;font-size:16px;line-height:24px">
                    <p style="margin: 0;">Thank you for using StartUp App! Use the following verification code to confirm your email address:</p>
                    <h2 style="margin: 20px 0; font-size: 28px; font-weight: 700; color:hsl(94, 59%, 35%);">${code}</h2>
                  </td>
                </tr>
                <tr>
                  <td align="left" bgcolor="#ffffff" style="padding:24px;font-family:'Source Sans Pro',Helvetica,Arial,sans-serif;font-size:16px;line-height:24px;border-bottom:3px solid #d4dadf">
                    <p style="margin:0">StartUp App</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td align="center" bgcolor="#e9ecef" style="padding:24px">
              <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px">
                <tr>
                  <td align="center" bgcolor="#e9ecef" style="padding:12px 24px;font-family:'Source Sans Pro',Helvetica,Arial,sans-serif;font-size:14px;line-height:20px;color:#666">
                    <p style="margin: 0;">You received this email because we received a request for StartUp App for your account.</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </body>
    </html>
    `;

    
    await sendEmail(email, 'Password Reset Request', message);

   
    return res.status(200).json({ message: 'تم إرسال الرمز بنجاح', user });

  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: `حدث خطأ: ${error.message}` });
  }
};


export const getLastActiveUsers = async (req, res) => {
  try {
    const activeUsers = await userModel
      .find({ lastLogin: { $ne: null } })
      .sort({ lastLogin: -1 }) 
      .limit(10);
    return res.status(200).json({ message: 'sucsses', activeUsers });
  } catch (error) {
    return res.status(500).json({ message: `catch error ${error}` });
  }
};
