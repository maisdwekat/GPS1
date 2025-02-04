import {roles} from '../../Servicess/roles.js'
export const endpoint={
    add:[roles.Admin,roles.User,roles.Investor],
    delete:[roles.Admin,roles.User,roles.Investor],
    update:[roles.User,roles.Admin,roles.Investor],
    byProject:[roles.User,roles.Admin],
    byInvestor: [roles.Investor,roles.Admin],
    download:[roles.User,roles.Admin,roles.Investor],
   

}
