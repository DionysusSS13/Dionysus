export enum DioPrefsPage {
  APPEARANCE = 'Appearance',
  JOBS = 'Jobs',
  LOADOUT = 'Loadout',
  LORE = 'Lore',
  OOC = 'OOC',
  SELECT = 'Select',
  SKILLS = 'Skills',
  SPECIES = 'Species',
}

export const HIDDEN_PAGES = [
  DioPrefsPage.SELECT,
  DioPrefsPage.SKILLS,
  // DioPrefsPage.SPECIES,
];
