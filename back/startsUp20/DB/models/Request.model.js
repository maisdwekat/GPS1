
import mongoose from 'mongoose';

const RequestSchema = new mongoose.Schema({
  investorId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'user',
    required: true,
  },
  investorName:{

  },
  projectId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'project',
    required: true,
  },
  investmentAmount: {
    type: Number,
    required: true,
    min: [0, "المبلغ لا يمكن أن يكون أقل من 0"],
  },
  investmentDate: {
    type: Date,
    default: Date.now,
  },
  investmentDuration: {
    type: Number,
    required: false,
    min: [0, "المدة لا يجب أن تكون بالسالب"],
  },
  ownershipPercentage: {
    type: Number,
    required: false,
    min: [0, "النسبة لا يمكن أن تكون أقل من 0"],
    max: [100, "النسبة لا يمكن أن تتجاوز 100"],
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
  requestStatus: {
    type: String,
    enum: ['معلق', 'موافق', 'مرفوض'],
    default: 'معلق',
  },
  requestDate: {
    type: Date,
    default: Date.now,
  },
}, {
  timestamps: true,
});

const Request = mongoose.model('Request', RequestSchema);

export default Request;

