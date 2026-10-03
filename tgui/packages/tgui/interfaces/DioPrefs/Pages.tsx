export enum DioPrefsPage {
  APPEARANCE = 'Appearance',
  JOBS = 'Jobs',
  // LOADOUT = 'Loadout',
  LORE = 'Lore',
  OOC = 'OOC',
  SELECT = 'Select',
  // SKILLS = 'Skills',
  SPECIES = 'Species',
}

export const PAGES_ORDERED = [
  DioPrefsPage.SELECT,
  DioPrefsPage.SPECIES,
  DioPrefsPage.APPEARANCE,
  DioPrefsPage.JOBS,
  DioPrefsPage.LORE,
  DioPrefsPage.OOC,
];

export const HIDDEN_PAGES: Array<DioPrefsPage> = [
  // DioPrefsPage.SELECT,
  // DioPrefsPage.SKILLS,
  // DioPrefsPage.SPECIES,
];
