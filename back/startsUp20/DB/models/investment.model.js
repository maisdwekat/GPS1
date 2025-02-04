
import mongoose from 'mongoose';

const InvestmentSchema = new mongoose.Schema(
  {
    investorId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'user',
      required: true,
    },
    investorName:{
      type: String,
      ref: 'user',
      required: true,
    },
    investorEmail:{
      type: String,
      ref: 'user',
      required: true,
    },
    projectId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'project',
      required: true,
    },
    projectName:{
      type: String,
      ref: 'project',
      required: true,
    },
    investmentAmount: {
      type: Number,
      required: true,
      min: [0, 'المبلغ لا يمكن أن يكون أقل من 0'],
    },
    investmentDate: {
      type: Date,
      default: Date.now,
    },
    investmentDuration: {
      type: Number,
      required: false,
      min: [0, 'المدة لا يجب أن تكون بالسالب'],
    },
    ownershipPercentage: {
      type: Number,
      required: false,
      min: [0, 'النسبة لا يمكن أن تكون أقل من 0'],
      max: [100, 'النسبة لا يمكن أن تتجاوز 100'],
    },
    dueDate: {
      type: Date,
      required: false,
    },
    investmentStatus: {
      type: String,
      enum: ['نشط', 'مكتمل'],
      default: 'نشط',
    },
    agreementFile: {
      type: String,
      required: false,
    },
  },
  {
    timestamps: true, 
  }
);

const Investment = mongoose.model('Investment', InvestmentSchema);

export default Investment;

