import { Schema, model, Types } from "mongoose";

const businessCanvasSchema = new Schema({
  projectId: {
    type: Types.ObjectId,
    ref: "project", 
    required: true,
  },
  keyPartners: {
    type: [String],
    required: false,
  },
  keyActivities: {
    type: [String], 
    required: false,
  },
  keyResources: {
    type: [String], 
    required: false,
  },
  valuePropositions: {
    type: [String], 
    required: false,
  },
  customerRelationships: {
    type: [String], 
    required: false,
  },
  channels: {
    type: [String], 
    required: false,
  },
  customerSegments: {
    type: [String], 
    required: false,
  },
  costStructure: {
    type: [String], 
    required: false,
  },
  revenueStreams: {
    type: [String], 
    required: false,
  },
}, {
  timestamps: true,
});


const businessCanvasModel = model("businessCanvas", businessCanvasSchema);

export { businessCanvasModel };
