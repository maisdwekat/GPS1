import {roles} from '../../Servicess/roles.js'
export const endpoint={
    add:[roles.Admin,roles.User],
    delete:[roles.Admin,roles.User],
    show:[roles.Admin,roles.User],
    showByLocation:[roles.Investor,roles.Admin,roles.User],
    showByStage:[roles.Investor,roles.Admin,roles.User],
    showByCategory:[roles.Investor,roles.Admin,roles.User],
    showByUser:[roles.Admin,roles.User],
    update:[roles.User,roles.Admin],
    addTasking:[roles.User,roles.Admin],
    delettask: [roles.User,roles.Admin],
    showTask:[roles.User,roles.Admin],
    addNote: [roles.User],
    deleteNote:[roles.User],
    updateNote:[roles.User],
    showNotes:[roles.User],
    addRatting:[roles.Investor],
    getAveregeRatting:[roles.Investor,roles.Admin,roles.User],
    getRating:[roles.User,roles.Admin],
}

