import { getLogoData, type Logo } from "./logo"

export interface ToolBar {
    logo: Logo
}


export function getToolBar(lang: string): ToolBar {
    const logo = getLogoData()
    return{
        logo
    }
}