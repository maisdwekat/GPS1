import { projectModel } from "../../../../DB/models/project.model.js"
import cloudenary from "../../../Servicess/cloudenary.js";
import mongoose from 'mongoose';

export const addProject = async (req, res) => {
 const {title , description , current_stage , isPublic , location ,category,website,email,summary,date}=req.body;

 const findProject=await projectModel.findOne({title:title})
 if(findProject){
    return res.json({message:"هذا البروجكت متوفر مسبقا"})
 }
 else{
    if(!req.file){
        return res.json({message:"الصورة مطلوبة "})
    }
    const {secure_url}= await cloudenary.uploader.upload(req.file.path,{folder:'project/image/'})
    req.body.image=secure_url;
    req.body.createdBy = req.user._id;
    req.body.name=req.user.name
    const project=await projectModel.create(req.body)
    if(!project){
        return res.json({message:"خطا في الاضافة"})
    }else{
        res.status(200).json({message:"تمت الاضافة بنجاخ",project})
    }
 }

  };
  export const deleteProject=async(req,res)=>{
    const {id}=req.params;
   const findProjectAndDelete=await  projectModel.findByIdAndDelete(id)
   if(!findProjectAndDelete){
    res.status(400).json({message:"error in delete"})
   }else{
    return res.status(200).message({message:"succsses"})
   }
  }
 export const findAll=async(req,res)=>{
    const findAllProject=await  projectModel.find({isPublic:true});
    if(!findAllProject){
        return res.status(400).json({message:"not found"})
    }else{
        return res.status(200).json({message:"all ", findAllProject})
    }
 }
 export const findByLocation=async(req,res)=>{
  const {location}=req.body;
  const findAllProject=await  projectModel.find({location:location});
  if(!findAllProject){
      return res.status(400).json({message:"not found"})
  }else{
      return res.status(200).json({message:"all ", findAllProject})
  }
}
export const findByStage=async(req,res)=>{
  const {current_stage}=req.body;
  const findAllProject=await  projectModel.find({current_stage:current_stage});
  if(!findAllProject){
      return res.status(400).json({message:"not found"})
  }else{
      return res.status(200).json({message:"all ", findAllProject})
  }
}
export const findByCategory=async(req,res)=>{
  const {category}=req.body;
  const findAllProject=await  projectModel.find({category:category});
  if(!findAllProject){
      return res.status(400).json({message:"not found"})
  }else{
      return res.status(200).json({message:"all ", findAllProject})
  }
}

 export const findAllByUser = async (req, res) => {

  const {userId} = req.params;
  console.log('User ID:', userId);

  const objectId = new mongoose.Types.ObjectId(userId);
  console.log('Object ID:', objectId);


  const findUserProjects = await projectModel.find({ createdBy: objectId});

  if (!findUserProjects) {
      return res.status(400).json({ message: "No projects found for this user" });
  } else {
      return res.status(200).json({ message: "User's projects", findUserProjects });
  }
};

 export const update = async (req, res) => {
    const { title, description, current_stage, isPublic, location, category ,website,email,summary,date} = req.body;

    const { id } = req.params;
  
    try {
     
      const findproject = await projectModel.findById(id);
  
      if (!findproject) {
        return res.status(404).json({ message: "Invalid ID: Project not found" });
      }
        
      
      const updatedProject = await projectModel.findByIdAndUpdate(
        id,
        {
          $set: {
            title: title || findproject.title,
            description: description || findproject.description,
            current_stage: current_stage || findproject.current_stage,
            isPublic: isPublic !== undefined ? isPublic : findproject.isPublic,
            location: location || findproject.location,
            category: category || findproject.category,
            website: website||findproject.website,
            email:email||findproject.email,
            summary:summary||findproject.summary,
            date:date||findproject.date,
            image: req.file
              ? (await cloudenary.uploader.upload(req.file.path, { folder: "project/image/" })).secure_url
              : findproject.image, 
      
          },
        },
        { new: true } 
      );
  
    
      if (!updatedProject) {
        return res.status(400).json({ message: "Invalid ID" });
      }
  
      return res.status(200).json({ message: "Success", updatedProject });
    } catch (error) {
      return res.status(500).json({ message: `Catch error: ${error.message}` });
    }
  };
  export const addTaskToCurrentStage = async (req, res) => {
    const { id } = req.params;
    const { question1, answer1, question2, answer2, question3, answer3, question4, answer4, question5, answer5, question6, answer6, question7, answer7, question8, answer8 } = req.body;
  
    try {
      const project = await projectModel.findById(id);
      if (!project) {
        return res.status(404).json({ message: "Project not found" });
      }
  
      
      let currentStage = project.stages.find((stage) => stage.stageName === project.current_stage);
  
      if (!currentStage) {
       
        currentStage = { stageName: project.current_stage, tasks: [] };
        project.stages.push(currentStage);
      }
  
     
      const newTask = {
        question1,
        answer1,
        question2,
        answer2,
        question3,
        answer3,
        question4,
        answer4,
        question5,
        answer5,
        question6,
        answer6,
        question7,
        answer7,
        question8,
        answer8,
      };
  

      currentStage.tasks.push(newTask);
  

      project.stages = project.stages.map((stage) =>
        stage.stageName === project.current_stage ? currentStage : stage
      );
  
      
      await project.save();
  
      return res.status(200).json({ message: "Task added successfully to current stage", project });
    } catch (error) {
      return res.status(500).json({ message: `Error adding task: ${error.message}` });
    }
  };

  export const deleteTaskFromCurrentStage = async (req, res) => {
    const { id, taskId } = req.params; 
  
    try {
     
      const project = await projectModel.findById(id);
      if (!project) {
        return res.status(404).json({ message: "Project not found" });
      }
  
      
      let currentStage = project.stages.find(
        (stage) => stage.stageName === project.current_stage
      );
  
      if (!currentStage) {
        return res.status(404).json({ message: "Current stage not found" });
      }
  
      
      const taskIndex = currentStage.tasks.findIndex(
        (task) => task._id.toString() === taskId
      );
  
      if (taskIndex === -1) {
        return res.status(404).json({ message: "Task not found" });
      }
  
      
      currentStage.tasks.splice(taskIndex, 1);
  
     
      project.stages = project.stages.map((stage) =>
        stage.stageName === project.current_stage ? currentStage : stage
      );
  
     
      await project.save();
  
      return res.status(200).json({
        message: "Task deleted successfully",
        project,
      });
    } catch (error) {
      return res.status(500).json({ message: `Error deleting task: ${error.message}` });
    }
  };
  
  export const getTasksForCurrentStage = async (req, res) => {
    const { id } = req.params; 
  
    try {
    
      const project = await projectModel.findById(id);
      if (!project) {
        return res.status(404).json({ message: "Project not found" });
      }
  
   
      const currentStage = project.stages.find(
        (stage) => stage.stageName === project.current_stage
      );
  
      if (!currentStage) {
        return res.status(404).json({ message: "Current stage not found" });
      }
  
    
      return res.status(200).json({
        message: "Tasks retrieved successfully",
        tasks: currentStage.tasks, 
      });
    } catch (error) {
      return res.status(500).json({ message: `Error retrieving tasks: ${error.message}` });
    }
  };



  export const getRecommendedProjects = async (req, res) => {
    const { id } = req.params;
  
    try {
      const project = await projectModel.findById(id);
      if (!project) {
        return res.status(404).json({ message: "المشروع غير موجود" });
      }
  
      const recommendedProjects = await projectModel.find({
        category: project.category,
        _id: { $ne: id },
      });
  
      return res.status(200).json({
        message: "تم جلب المشاريع المقترحة بنجاح",
        recommendedProjects,
      });
    } catch (error) {
      return res.status(500).json({ message: `Error: ${error.message}` });
    }
  };
  
  
  export const updateSearchCount = async (req, res) => {
    const { id } = req.params;
  
    try {
      const project = await projectModel.findByIdAndUpdate(
        id,
        { $inc: { searchCount: 1 } },
        { new: true }
      );
  
      if (!project) {
        return res.status(404).json({ message: "المشروع غير موجود" });
      }
  
      return res.status(200).json({ message: "تم تحديث عدد مرات البحث", project });
    } catch (error) {
      return res.status(500).json({ message: `Error: ${error.message}` });
    }
  };
  
  
  export const getTopSearchedProjects = async (req, res) => {
    try {
      const topProjects = await projectModel.find().sort({ searchCount: -1 }).limit(10);
  
      return res.status(200).json({
        message: "تم جلب المشاريع الأكثر بحثًا بنجاح",
        topProjects,
      });
    } catch (error) {
      return res.status(500).json({ message: `Error: ${error.message}` });
    }
  };

  
  export const searchProjects = async (req, res) => {
    const { query } = req.query; 
  
    try {
      if (!query) {
        return res.status(400).json({ message: "يرجى تقديم نص للبحث" });
      }
  
     
      const projects = await projectModel.find({
        $or: [
          { title: { $regex: new RegExp(query, "i") } },
          { description: { $regex: new RegExp(query, "i") } },
          { category: { $regex: new RegExp(query, "i") } },
        ],
      });
  
      if (projects.length === 0) {
        return res.status(404).json({ message: "لا توجد مشاريع مطابقة للبحث" });
      }
  
      return res.status(200).json({
        message: "تم جلب المشاريع بنجاح",
        projects,
      });
    } catch (error) {
      return res.status(500).json({ message: `Error: ${error.message}` });
    }
  };

  
 export const getNotes = async (req, res) => {
  try {
    const { projectId } = req.params;

    // البحث عن المشروع وتأكيد ملكية المستخدم
    const project = await projectModel.findById(projectId);
    if (!project) {
      return res.status(404).json({ message: 'Project not found' });
    }
   
    res.status(200).json(project.notes);
  } catch (err) {
    res.status(500).json({ message: 'Error retrieving notes', error: err.message });
  }
 };

  export const addNoteToProject = async (req, res) => {
    const { id } = req.params;
    const { noteText } = req.body;
  
    try {
      const project = await projectModel.findById(id);
      if (!project) {
        return res.status(404).json({ message: "المشروع غير موجود" });
      }
      
      // إضافة الملاحظة إلى المصفوفة
      project.notes.push({
        noteText,
        createdAt: new Date(),
      });
  
      // حفظ المشروع بعد إضافة الملاحظة
      await project.save();
  
      return res.status(200).json({ message: "تم إضافة الملاحظة بنجاح", project });
    } catch (error) {
      return res.status(500).json({ message: `حدث خطأ: ${error.message}` });
    }
  };

  export const updateNote = async (req, res) => {
    const { id, noteId } = req.params;  // التقاط الـ projectId و الـ noteId من الرابط
    const { noteText } = req.body;  // التقاط النص الجديد للملاحظة
  
    try {
      // العثور على المشروع باستخدام الـ projectId
      const project = await projectModel.findById(id);
      if (!project) {
        return res.status(404).json({ message: "المشروع غير موجود" });
      }
  
      // العثور على الملاحظة باستخدام الـ noteId
      const note = project.notes.id(noteId);
      if (!note) {
        return res.status(404).json({ message: "الملاحظة غير موجودة" });
      }
  
      // تحديث النص الخاص بالملاحظة
      note.noteText = noteText;
      note.createdAt=new Date();
  
      // حفظ المشروع بعد تعديل الملاحظة
      await project.save();
  
      return res.status(200).json({ message: "تم تعديل الملاحظة بنجاح", project });
    } catch (error) {
      return res.status(500).json({ message: `حدث خطأ: ${error.message}` });
    }
  };
  

  export const deleteNote = async (req, res) => {
    const { id, noteId } = req.params;  // التقاط الـ projectId و الـ noteId من الرابط
  
    try {
      // العثور على المشروع باستخدام الـ projectId
      const project = await projectModel.findById(id);
      if (!project) {
        return res.status(404).json({ message: "المشروع غير موجود" });
      }
  
      // العثور على الملاحظة باستخدام الـ noteId
      const note = project.notes.id(noteId);
      if (!note) {
        return res.status(404).json({ message: "الملاحظة غير موجودة" });
      }
      // حذف الملاحظة من مصفوفة الملاحظات
      note.remove();
  
      // حفظ المشروع بعد حذف الملاحظة
      await project.save();
  
      return res.status(200).json({ message: "تم حذف الملاحظة بنجاح", project });
    } catch (error) {
      return res.status(500).json({ message: `حدث خطأ: ${error.message}` });
    }
  };


// إضافة تقييم للمشروع
export const addRating = async (req, res) => {
  try {
    const {projectId} = req.params;
    const {  rating } = req.body;
    const investorId = req.user._id;

    // التحقق من أن المستخدم مستثمر
    if (req.user.role !== 'investor') {
      return res.status(403).json({ message: 'Access denied: Only investors can rate projects.' });
    }

    // العثور على المشروع
    const project = await projectModel.findById(projectId);
    if (!project) {
      return res.status(404).json({ message: 'Project not found' });
    }

    // التحقق من أن المستثمر لم يقم بالتقييم مسبقًا
    const existingRating = project.ratings.find(r => r.investor.toString() === investorId.toString());
    if (existingRating) {
      return res.status(400).json({ message: 'You have already rated this project' });
    }

    // إضافة التقييم
    project.ratings.push({ investor: investorId, rating:rating });
    
    // تحديث متوسط التقييم
    const totalRatings = project.ratings.reduce((sum, r) => sum + r.rating, 0);
    project.averageRating = totalRatings / project.ratings.length;

    await project.save();
    res.status(200).json({ message: 'Rating added successfully', project });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

export const getAverageRating = async (req, res) => {
  try {
    const { projectId } = req.params;

    const project = await projectModel.findById(projectId).select('averageRating');
    if (!project) {
      return res.status(404).json({ message: 'Project not found' });
    }

    res.status(200).json({ averageRating: project.averageRating });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// export const getProjectRatings = async (req, res) => {
//   try {
//     const { projectId } = req.params;

//     const project = await projectModel.findById(projectId).select('ratings');
//     if (!project) {
//       return res.status(404).json({ message: 'Project not found' });
//     }

//     res.status(200).json({ ratings: project.ratings });
//   } catch (error) {
//     res.status(500).json({ message: 'Server error', error: error.message });
//   }
// };


  
  
  