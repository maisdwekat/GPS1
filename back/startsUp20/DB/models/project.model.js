import { Schema, Types, model } from "mongoose";

const taskSchema = new Schema({
  question1: {
    type: String,
    required: false,
  },
  answer1: {
    type: Boolean, 
    enum: [true, false],
    required: false,
  },
  question2: {
    type: String,
    required: false,
  },
  answer2: {
    type: Boolean, 
    enum: [true, false],
    required: false,
  },
  question3: {
    type: String,
    required: false,
  },
  answer3: {
    type: Boolean,
    enum: [true, false],
    required: false,
  },
  question4: {
    type: String,
    required: false,
  },
  answer4: {
    type: Boolean, 
    enum: [true, false],
    required: false,
  },
  question5: {
    type: String,
    required: false,
  },
  answer5: {
    type: Boolean, 
    enum: [true, false],
    required: false,
  },
  question6: {
    type: String,
    required: false,
  },
  answer6: {
    type: Boolean, 
    enum: [true, false],
    required: false,
  },
  question7: {
    type: String,
    required: false,
  },
  answer7: {
    type: Boolean, 
    enum: [true, false],
    required: false,
  },
  question8: {
    type: String,
    required: false,
  },
  answer8: {
    type: Boolean, 
    enum: [true, false],
    required: false,
  },
});

// تعريف مخطط المراحل
const stageSchema = new Schema({
  stageName: {
    type: String,
    required: false,
  },
  tasks: [taskSchema], 
});

// تعريف مخطط الملاحظة
const noteSchema = new Schema({
  noteText: {
    type: String,
    required: false, // الملاحظة النصية
  },
  createdAt: {
    type: Date,
    default: Date.now, // تاريخ إضافة الملاحظة
  },
});
const ratingSchema = new Schema({
  investor: {
    type: Types.ObjectId, 
    ref: "user",
    required: false,
  },
  rating: {
    type: Number,
    required: false,
    min: 1, 
    max: 5, 
  },
});

// تعريف مخطط المشروع
const projectSchema = new Schema({
  title: {
    type: String,
    required: true,
    trim: true,
  },
  name:{
   type:String,
   required: true,
   ref: 'user',
  },
  description: {
    type: String,
    required: true,
    trim: true,
  },
  current_stage: {
    type: String,
    required: true, 
  },
  isPublic: {
    type: Boolean,
    required: true,
    enum: [true, false],
    default: false,
  },
  location: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  website:{
    type: String,
    required: false,
  },
  email:{
    type: String,
    required: false,
  },
  summary:{
    type: String,
    required: false,
  },
  date:{
    type: Date,
    required:true,
  },
  image: {
    type: String,
    required: true,
  },
  createdBy: {
    type: Types.ObjectId,
    ref: 'user',
    required: [true, 'مطلوب تحديد مالك المشروع'],
  },
  stages: [stageSchema], 
  searchCount: {
    type: Number,
    default: 0,
  },
  recommendations: [
    {
      type: Types.ObjectId,
      ref: "project",
    },
  ],
  notes: [noteSchema],
  notes: [noteSchema],
  ratings: [ratingSchema], 
  averageRating: {
      type: Number,
      default: 0,
    },
}, {
  timestamps: true, 
});

const projectModel = model("project", projectSchema);

export { projectModel };
