import {roles} from '../../Servicess/roles.js'
export const endpoint={
    add:[roles.User, roles.Admin],
    delete:[roles.Admin,roles.User],
    show:[roles.Admin,roles.User,roles.Investor],
    update:[roles.Admin,roles.User]
 
}
