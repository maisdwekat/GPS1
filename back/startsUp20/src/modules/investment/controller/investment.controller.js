import path from 'path';
import fs from 'fs/promises';
import cron from 'node-cron'; 
import Investment from '../../../../DB/models/investment.model.js';
import { sendNotification } from "../../notification/notifacation.js";
import { projectModel } from "../../../../DB/models/project.model.js";
import { userModel } from "../../../../DB/models/user.model.js";
import cloudenary from "../../../Servicess/cloudenary.js";

export const addInvestment = async (req, res) => {
  const {
    investmentAmount,
    investmentDuration,
    ownershipPercentage,
    dueDate,
  } = req.body;
  const investorId = req.user._id;
  const investorName = req.user.name;
  const investorEmail = req.user.email;
  const projectId = req.params.projectId;
    
  try {
    const project = await projectModel.findById(projectId).select('title');
    
    const projectName = project ? project.title : null;
    
    const { secure_url } = await cloudenary.uploader.upload(req.file.path, {
        folder: "user/file/",
      });

      req.body.agreementFile = secure_url; 

    const newInvestment = new Investment({
      investorId,
      investorName,
      investorEmail,
      projectId,
      projectName,
      investmentAmount,
      investmentDuration,
      ownershipPercentage,
      dueDate,
      agreementFile,
    });

    await newInvestment.save();

    res.status(201).json({ message: 'تمت إضافة الاستثمار بنجاح', investment: newInvestment });
  } catch (error) {
    res.status(500).json({ error: 'حدث خطأ أثناء إضافة الاستثمار', details: error.message });
  }
};


export const updateInvestment = async (req, res) => {
  try {
    const { investmentId } = req.params;
    const updates = req.body;

    if (req.file) {
      updates.agreementFile = req.file.path;
    }

    const updatedInvestment = await Investment.findByIdAndUpdate(investmentId, updates, {
      new: true,
      runValidators: true,
    });

    if (!updatedInvestment) {
      return res.status(404).json({ error: 'لم يتم العثور على الاستثمار' });
    }

    res.status(200).json({ message: 'تم تعديل الاستثمار بنجاح', investment: updatedInvestment });
  } catch (error) {
    res.status(500).json({ error: 'حدث خطأ أثناء تعديل الاستثمار', details: error.message });
  }
};


export const deleteInvestment = async (req, res) => {
  try {
    const { investmentId } = req.params;

    const deletedInvestment = await Investment.findByIdAndDelete(investmentId);

    if (!deletedInvestment) {
      return res.status(404).json({ error: 'لم يتم العثور على الاستثمار' });
    }

    res.status(200).json({ message: 'تم حذف الاستثمار بنجاح' });
  } catch (error) {
    res.status(500).json({ error: 'حدث خطأ أثناء حذف الاستثمار', details: error.message });
  }
};


export const getInvestmentsByInvestor = async (req, res) => {
  try {
    const { investorId } = req.params;

    const investments = await Investment.find({ investorId });

    res.status(200).json({ investments });
  } catch (error) {
    res.status(500).json({ error: 'حدث خطأ أثناء جلب الاستثمارات', details: error.message });
  }
};


export const getInvestmentsByProject = async (req, res) => {
  try {
    const { projectId } = req.params;

    const investments = await Investment.find({ projectId });

    res.status(200).json({ investments });
  } catch (error) {
    res.status(500).json({ error: 'حدث خطأ أثناء جلب الاستثمارات', details: error.message });
  }
};


export const downloadAgreementFile = async (req, res) => {
  try {
    const { investmentId } = req.params;

    const investment = await Investment.findById(investmentId);

    if (!investment || !investment.agreementFile) {
      return res.status(404).json({ message: 'الملف غير موجود' });
    }

    const filePath = path.resolve('uploads', investment.agreementFile);

    fs.exists(filePath, (exists) => {
      if (exists) {
        res.download(filePath);
      } else {
        res.status(404).json({ message: 'الملف غير موجود' });
      }
    });
  } catch (error) {
    res.status(500).json({ message: 'خطأ في الخادم', error: error.message });
  }
};

