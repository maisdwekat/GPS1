import mongoose from 'mongoose';


const ActionRequestSchema = new mongoose.Schema(
  {
    investmentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Investment', 
      required: true,
    },
    requestedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'user',
      required: true,
    },
    receiverId:{
      type: mongoose.Schema.Types.ObjectId,
      ref: 'user',
      required: true,
    },
    requestType: {
      type: String,
      enum: ['إلغاء', 'تعديل','حذف'], 
      required: true,
    },
    newDetails: {
      investmentAmount: {
        type: Number, 
        min: [0, 'المبلغ لا يمكن أن يكون أقل من 0'],
      },
      investmentDuration: {
        type: Number, 
        min: [0, 'المدة لا يجب أن تكون بالسالب'],
      },
      ownershipPercentage: {
        type: Number, 
        min: [0, 'النسبة لا يمكن أن تكون أقل من 0'],
        max: [100, 'النسبة لا يمكن أن تتجاوز 100'],
      },
      dueDate: {
        type: Date, 
      },
      investmentStatus: {
        type: String, 
        enum: ['نشط', 'مكتمل', 'قيد المفاوضات'],
      },
      agreementFile: {
        type: String, 
        required: false,
      },
    },
    status: {
      type: String,
      enum: ['قيد المراجعة', 'مقبول', 'مرفوض'], 
      default: 'قيد المراجعة',
    },
  },
  {
    timestamps: true, 
  }
);


const ActionRequest = mongoose.model('ActionRequest', ActionRequestSchema);

export default ActionRequest;
