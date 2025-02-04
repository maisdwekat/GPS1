import { grantModel } from "../../../../DB/models/grant.model.js";
import { userModel } from "../../../../DB/models/user.model.js";
import { sendNotification } from "../../notification/notifacation.js";

export const Addgrant=async(req , res)=>{
    const {nameOfCompany, nameOfGrant,description,DateOfEndoFGrant}=req.body;
   req.body.createdBy=req.user._id;
   req.body.userName=req.user.name;
   const add=await grantModel.create(req.body)
   if(!add){
    res.status(400).json({message:"error in add"})
   }
   else{
    const users = await userModel.find({ role: "user" }); 
    
    
    users.forEach(async (user) => {
      if (user.fcmToken) {
        const message = `تم إضافة منحة جديدة: ${nameOfGrant}. تحقق منها الآن!`;
        await sendNotification(user.fcmToken, message); 
      }
    });

    res.status(400).json({message:"message",add})
   }
}
export const getAllgrant=async(req,res)=>{
    const getAll=await grantModel.find({});
    if(!getAll){
        res.status(400).json({message:"no data"})
    }
    else{
        res.status(400).json({message:"succsses", getAll}) 
    }
}
export const deleteGrant=async(req,res)=>{
    const {id}=req.params;
    const deleteOneGrant=await grantModel.findByIdAndDelete(id);
    if(!deleteOneGrant){
        res.status(400).json({message:"error delete"})
    }
    else{
        res.status(400).json({message:"succsses", deleteOneGrant}) 
 
    }
}
export const updateGrant=async(req,res)=>{
    const {id}=req.params;
    const {nameOfCompany, nameOfGrant,description,DateOfEndoFGrant}=req.body;
    try{
        const grant=await grantModel.findById(id);
        if(!grant){
            res.status(400).json({message:"grant not found"})
        }
        else{
            grant.nameOfCompany=nameOfCompany ||  grant.nameOfCompany,
            grant.nameOfGrant=nameOfGrant || grant.nameOfGrant;
            grant.description=description || grant.description;
            grant.DateOfEndoFGrant=DateOfEndoFGrant || grant.DateOfEndoFGrant;
            const update=await grant.save()
            return res.status(200).json({
                message:"update successfully" ,
                update
             })


        }


    }catch(error){
        return res.status(500).json({message:`error ${error}`})
    }
}