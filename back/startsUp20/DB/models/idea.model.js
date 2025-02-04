
import { Schema, Types, model } from "mongoose";


const likesSchema = new Schema({
  createdBy: {
    type: Types.ObjectId,
    ref: 'user',
    required: true
  },
  commentId: {
    type: Types.ObjectId,
    ref: 'comment',
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});


const ideaLikesSchema = new Schema({
  createdBy: {
    type: Types.ObjectId,
    ref: 'user',
    required: true
  },
  ideaId: {
    type: Types.ObjectId,
    ref: 'Idea',
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});


const commentSchema = new Schema({
  createdBy: {
    type: Types.ObjectId,
    ref: 'user',
    required: true
  },
  content: {
    type: String,
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  userName: {
    type: String,
    ref: 'user',
    required: true
  },
  ideaId: {
    type: Types.ObjectId,
    ref: 'Idea',
    required: true
  },
  likes: [likesSchema] 
});


const ideaSchema = new Schema({
  description: {
    type: String,
    required: true
  },
  emailContact: {
    type: String,
    ref: 'user',
    required: true
  },
  isPublic: {
    type: Boolean,
    default: true
  },
  category: {
    type: String,
    required: true
  },
  comments: [commentSchema], 
  likes: [ideaLikesSchema], 
  createdBy: {
    type: Types.ObjectId,
    ref: 'user',
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});


const LikeOnComment = model('LikeOnComment', likesSchema);
const LikeOnIdea = model('LikeOnIdea', ideaLikesSchema);
const CommentModel = model('Comment', commentSchema);
const Idea = model('Idea', ideaSchema);


export {
  LikeOnComment,
  LikeOnIdea,
  CommentModel,
  Idea
};

