import { businessCanvasModel } from "../../../../DB/models/businessCanva.model.js";
import mongoose from 'mongoose';


export const getBusinessCanvas = async (req, res) => {

  try {
  
    const { projectId } = req.params;
    const objectId = new mongoose.Types.ObjectId(projectId);
    console.log('project ID:', projectId);
    console.log('object ID:', objectId);
    const canvas = await businessCanvasModel.findOne({ projectId:objectId });
    if (!canvas) {
      return res.status(404).json({ message: 'Business Canvas not found for this project' });
    }
    res.status(200).json(canvas);
  } catch (err) {
    res.status(500).json({ message: 'Error retrieving Business Canvas', error: err.message });
  }
};

export const addBusinessCanvas = async (req, res) => {
  try {
    const{
    keyPartners,
    keyActivities,
    keyResources,
    valuePropositions,
    customerRelationships,
    channels,
    customerSegments,
    costStructure,
    revenueStreams}=req.body;

    const { projectId } = req.params;
    const objectId = new mongoose.Types.ObjectId(projectId);
   
    const existingCanvas = await businessCanvasModel.findOne({ projectId:objectId });
    if (existingCanvas) {
      return res.status(400).json({ message: 'Business Canvas already exists for this project' });
    }

    const canvas = new businessCanvasModel({
      projectId: objectId,
      keyPartners,
      keyActivities,
      keyResources,
      valuePropositions,
      customerRelationships,
      channels,
      customerSegments,
      costStructure,
      revenueStreams,
  });
    await canvas.save();
    res.status(201).json(canvas);
  } catch (err) {
    res.status(500).json({ message: 'Error creating Business Canvas', error: err.message });
  }
};

export const updateBusinessCanvas = async (req, res) => {
  try {
    const { projectId } = req.params;
    const{
      keyPartners,
      keyActivities,
      keyResources,
      valuePropositions,
      customerRelationships,
      channels,
      customerSegments,
      costStructure,
      revenueStreams}=req.body;
    const objectId = new mongoose.Types.ObjectId(projectId);

    const canvas = await businessCanvasModel.findOne({ projectId:objectId });
    if (!canvas) {
      return res.status(404).json({ message: 'Business Canvas not found for this project' });
    }
    Object.assign(canvas, req.body);
    await canvas.save();
    res.status(200).json(canvas);
  } catch (err) {
    res.status(500).json({ message: 'Error updating Business Canvas', error: err.message });
  }
};


export const deleteBusinessCanvas = async (req, res) => {
  try {
    const { projectId } = req.params;

    
    const canvas = await businessCanvasModel.findOneAndDelete({ projectId });
    if (!canvas) {
      return res.status(404).json({ message: 'Business Canvas not found for this project' });
    }

    res.status(200).json({ message: 'Business Canvas deleted successfully' });
  } catch (err) {
    res.status(500).json({ message: 'Error deleting Business Canvas', error: err.message });
  }
};
