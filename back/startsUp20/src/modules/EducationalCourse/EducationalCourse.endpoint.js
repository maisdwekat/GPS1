import {roles} from '../../Servicess/roles.js'
export const endpoint={
    add:[roles.Admin],
    delete:[roles.Admin],
    show:[roles.Admin,roles.User],
    update:[roles.Admin]
 
}