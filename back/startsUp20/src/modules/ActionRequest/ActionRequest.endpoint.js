import {roles} from '../../Servicess/roles.js'
export const endpoint={

    add:[roles.Admin,roles.User,roles.Investor],
    showByinvestor:[roles.Admin,roles.Investor],
   show:[roles.Admin , roles.Investor , roles.User],
   check:[roles.Investor]
    
}
