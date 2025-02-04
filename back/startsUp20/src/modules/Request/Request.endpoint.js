import {roles} from '../../Servicess/roles.js'
export const endpoint={
    show:[roles.Admin,roles.User],
    add:[roles.Admin,roles.Investor],
    update:[roles.User,roles.Admin],
    
}
