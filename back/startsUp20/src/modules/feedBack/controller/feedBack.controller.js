import { feedBackModel } from "../../../../DB/models/feedback.model.js"

export const addFeedBack=async(req , res)=>{
    const {description}=req.body
    req.body.createdBy=req.user._id;
    req.body.userName=req.user.name
    const AddFeed=await   feedBackModel.create(req.body);
    res.json(AddFeed)
}
export  const deleteFeedBack=async(req,res)=>{
    const {id}=req.params;
    const deleteFeed=await feedBackModel.findByIdAndDelete(id);
    if(!deleteFeed){
        res.status(400).json({message:"error in delete"})
    }else{
        res.status(200).json({message:"succsses"})
    }

}
export const showAll=async(req,res)=>{
    const showAll=await feedBackModel.find({});
   res.status(200).json({message:"succsses", showAll})
}
export const showUserfeed=async(req , res)=>{
    const {id}=req.params;
    const show=await feedBackModel.findById(id);
    res.status(200).json({message:"succsses", show})
}