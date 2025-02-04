import { Idea, CommentModel,LikeOnIdea } from "../../../../DB/models/idea.model.js";
import { Types } from "mongoose";
import mongoose from 'mongoose';
export const createIdea = async (req, res) => {
    const { description, isPublic, category } = req.body;


    req.body.createdBy = req.user._id;
    const idea = new Idea({
        description,
        isPublic,
        category,
        emailContact:req.user.email,
        comments: [],
        likes: [],
        createdBy: req.user._id
    })
    const saveIdea = await idea.save();
    res.status(200).json({ message: "save", saveIdea })
}

export const addComment = async (req, res) => {
    const { content } = req.body;
    const { IdeaId } = req.params;


    try {
        const updatedIdea = await Idea.updateOne(
            { _id: IdeaId },
            {
                $push: {
                    comments: {
                        content,
                        createdBy: req.user._id,
                        userName: req.user.name,
                        createdAt: new Date()
                    }
                }
            }
        );


        if (updatedIdea.modifiedCount === 0) {
            return res.status(400).json({ message: "Idea not found or comment not added" });
        }

        return res.status(200).json({ message: "Comment added successfully" });
    } catch (error) {
        return res.status(500).json({ message: "Error adding comment", error: error.message });
    }
};





export const AddLikeToComment = async (req, res) => {
    const { commentId } = req.params;
    const userId = req.user._id;
    try {

        const objectIdCommentId = new Types.ObjectId(commentId);


        const updatedIdea = await Idea.updateOne(
            { "comments._id": objectIdCommentId },
            { $push: { "comments.$.likes": userId } }
        );

        if (updatedIdea.modifiedCount === 0) {
            return res.status(404).json({ message: "Comment not found" });
        }

        return res.status(200).json({ message: "Like added successfully" });

    } catch (error) {
        return res.status(500).json({ message: "Error adding like", error: error.message });
    }
};





export const getIdea = async (req, res) => {
    const { id } = req.params;
    const getIdeas = await Idea.findById(id);
    if (!getIdeas) {
        res.status(400).json({ message: "not found" })
    }
    else {
        res.status(200).json({ message: "succsses", getIdeas })
    }
}

export const getAllIdea = async (req, res) => {

    const getIdeas = await Idea.find({isPublic:true});
    if (!getIdeas) {
        res.status(400).json({ message: "not found" })
    }
    else {
        res.status(200).json({ message: "succsses", getIdeas })
    }
}
export const getAllIdeaForUser = async (req, res) => {
  const { id } = req.params;
  const objectId = new mongoose.Types.ObjectId(id);

  const getIdeas = await Idea.find({createdBy:objectId});
  if (!getIdeas) {
      res.status(400).json({ message: "not found" })
  }
  else {
      res.status(200).json({ message: "succsses", getIdeas })
  }
}






export const deleteIdea = async (req, res) => {
    const { id } = req.params;
    const userId = req.user._id;

    try {
        const idea = await Idea.findById(id);

        if (!idea) {
            return res.status(404).json({ message: "Idea not found" });
        }


        console.log("UserId from req:", userId);
        console.log("CreatedBy from Idea:", idea.createdBy.toString());


        if (idea.createdBy.toString() !== userId.toString()) {
            return res.status(403).json({ message: "You are not authorized to delete this idea" });
        }

        await idea.deleteOne();

        return res.status(200).json({ message: "Idea deleted successfully" });
    } catch (error) {
        return res.status(500).json({ message: "Error deleting idea", error: error.message });
    }
};




export const updateIdea = async (req, res) => {
    const { id } = req.params;
    const { description, isPublic, categrory } = req.body;
    const userId = req.user._id;
    const emailContact = req.user.email;
    try {

        const idea = await Idea.findById(id);

        if (!idea) {
            return res.status(404).json({ message: "Idea not found" });
        }


        if (idea.createdBy.toString() !== userId.toString()) {
            return res.status(403).json({ message: "You are not authorized to update this idea" });
        }


        idea.description = description || idea.description;
        idea.isPublic = isPublic !== undefined ? isPublic : idea.isPublic;
        idea.categrory = categrory || idea.categrory;
        idea.emailContact=emailContact || idea.emailContact


        const updatedIdea = await idea.save();

        return res.status(200).json({
            message: "Idea updated successfully",
            updatedIdea,
        });
    } catch (error) {
        return res.status(500).json({ message: "Error updating idea", error: error.message });
    }
};



export const getAllCommentsInIdea = async (req, res) => {
    const { id } = req.params;

    try {

        const findIdea = await Idea.findById(id);


        if (!findIdea) {
            return res.status(404).json({ message: "Idea not found" });
        }


        return res.status(200).json({
            message: "Comments retrieved successfully",
            comments: findIdea.comments,
        });
    } catch (error) {
        return res.status(500).json({ message: "Error retrieving comments", error: error.message });
    }
};


export const deleteCommentFromIdea = async (req, res) => {
    const { ideaId, commentId } = req.params;
    const userId = req.user._id; 
  
    try {
     
      const findIdea = await Idea.findById(ideaId);
  
      if (!findIdea) {
        return res.status(404).json({ message: "Idea not found" });
      }
  
     
      const commentIndex = findIdea.comments.findIndex(
        (comment) => comment._id.toString() === commentId
      );
  
      if (commentIndex === -1) {
        return res.status(404).json({ message: "Comment not found" });
      }
  
      const comment = findIdea.comments[commentIndex];
  
      
      if (
        comment.createdBy.toString() !== userId.toString() &&
        findIdea.createdBy.toString() !== userId.toString()
      ) {
        return res.status(403).json({ message: "You are not authorized to delete this comment" });
      }
  
    
      findIdea.comments.splice(commentIndex, 1);
  
  
      await findIdea.save({ validateBeforeSave: false });
  
      return res.status(200).json({ message: "Comment deleted successfully" });
    } catch (error) {
      return res.status(500).json({ message: "Error deleting comment", error: error.message });
    }
  };
  





  export const updateCommentInIdea = async (req, res) => {
    const { ideaId, commentId } = req.params;
    const { content } = req.body;
    const userId = req.user._id; 
  
    try {
     
      const findIdea = await Idea.findById(ideaId);
  
      if (!findIdea) {
        return res.status(404).json({ message: "Idea not found" });
      }
  
    
      const commentIndex = findIdea.comments.findIndex(
        (comment) => comment._id.toString() === commentId
      );
  
      if (commentIndex === -1) {
        return res.status(404).json({ message: "Comment not found" });
      }
  
      const comment = findIdea.comments[commentIndex];
  
   
      if (
        comment.createdBy.toString() !== userId.toString() &&
        findIdea.createdBy.toString() !== userId.toString()
      ) {
        return res.status(403).json({ message: "You are not authorized to update this comment" });
      }
  
      
      findIdea.comments[commentIndex].content = content;
  
     
      await findIdea.save({ validateBeforeSave: false });
  
      return res.status(200).json({ message: "Comment updated successfully" });
    } catch (error) {
      return res.status(500).json({ message: "Error updating comment", error: error.message });
    }
  };
  





export const deleteLikeInComment = async (req, res) => {
  const { ideaId, commentId, likeId } = req.params;
  const userId = req.user._id;
  try {
  
    const findIdea = await Idea.findById(ideaId);

    if (!findIdea) {
      return res.status(404).json({ message: "Idea not found" });
    }

    const comment = findIdea.comments.find(
      (comment) => comment._id.toString() === commentId
    );

    if (!comment) {
      return res.status(404).json({ message: "Comment not found" });
    }


    const likeIndex = comment.likes.findIndex(
      (like) => like._id.toString() === likeId
    );

    if (likeIndex === -1) {
      return res.status(404).json({ message: "Like not found" });
    }

    const like = comment.likes[likeIndex];

  
    if (like.createdBy.toString() !== userId.toString()) {
      return res.status(403).json({ message: "You are not authorized to remove this like" });
    }

  
    comment.likes.splice(likeIndex, 1);


    await findIdea.save({ validateBeforeSave: false });

    return res.status(200).json({ message: "Like removed successfully" });
  } catch (error) {
    return res.status(500).json({ message: "Error removing like", error: error.message });
  }
};


export const getRecommendedIdeas = async (req, res) => {
  try {
   
    const recommendedIdeas = await Idea.aggregate([
    
      { $unwind: "$likes" },
    
      {
        $group: {
          _id: "$_id", 
          description: { $first: "$description" }, 
          createdBy: { $first: "$createdBy" }, 
          emailContact: { $first: "$emailContact" }, 
          isPublic: { $first: "$isPublic" }, 
          category: { $first: "$category" }, 
          totalLikes: { $sum: 1 } 
        }
      },
     
      { $sort: { totalLikes: -1 } },
    
      { $limit: 10 } 
    ]);

    res.status(200).json(recommendedIdeas);
  } catch (error) {
    res.status(500).json({
      message: "Error retrieving recommended ideas",
      error: error.message,
    });
  }
};




export const AddLikeToidea=async(req,res)=>{
const {ideaId}=req.params;
req.body.createdBy=req.user._id
try {
 
  const existingLike = await LikeOnIdea.findOne({ createdBy: req.user._id, ideaId });

  if (existingLike) {
    return res.status(400).json({ message: 'You already liked this post.' });
  }


  const like = new LikeOnIdea({ createdBy: req.user._id, ideaId });
  await like.save();
 



  await Idea.findByIdAndUpdate(ideaId, { $push: { likes: like } });

  res.status(201).json({ message: 'Like added successfully.', like });
} catch (error) {
  res.status(500).json({ message: 'Error adding like.', error });
}
}
export const findlikes=async(req,res)=>{
  const { ideaId } = req.params;
  try {
    const likes = await LikeOnIdea.find({ ideaId }).populate('createdBy', 'name email');
    res.status(200).json({ likes });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching likes.', error });
  }
  
}


export const deletelikeFromIdea = async (req, res) => {
  const { ideaId } = req.params;
  const userId = req.user._id; 

  try {
   
    const like = await LikeOnIdea.findOne({ createdBy: userId, ideaId });
    
    if (!like) {
      return res.status(404).json({ message: 'Like not found or not owned by the user.' });
    }

 
    await Idea.findByIdAndUpdate(
      ideaId,
      { $pull: { likes: { createdBy: userId } } },
      { new: true } 
    );

   
    await LikeOnIdea.findByIdAndDelete(like._id);

    res.status(200).json({ message: 'Like removed successfully.' });
  } catch (error) {
    res.status(500).json({ message: 'Error removing like.', error });
  }
};
