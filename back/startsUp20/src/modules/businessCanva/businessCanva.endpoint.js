import {roles} from '../../Servicess/roles.js'
export const endpoint={
    add:[roles.User],
    delete:[roles.User],
    show:[roles.Admin,roles.User],
    update:[roles.User],
}