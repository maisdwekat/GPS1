import {roles} from '../../Servicess/roles.js'
export const endpoint={
    add:[roles.User,roles.Investor,roles.Admin],
 
    show:[roles.Admin,roles.User,roles.Investor],
 
}
