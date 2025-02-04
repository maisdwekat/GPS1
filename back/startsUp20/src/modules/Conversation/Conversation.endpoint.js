import {roles} from '../../Servicess/roles.js'
export const endpoint={
    add:[roles.User],
    adminReply:[roles.Admin],
    delete:[roles.Admin,roles.User],
    show:[roles.Admin,roles.User],
 
}
