import { BooleanLike } from 'common/react';

import { sendAct } from '../../backend';
import { Gender } from './preferences/gender';

export enum Food {
  Alcohol = 'ALCOHOL',
  Breakfast = 'BREAKFAST',
  Cloth = 'CLOTH',
  Dairy = 'DAIRY',
  Fried = 'FRIED',
  Fruit = 'FRUIT',
  Grain = 'GRAIN',
  Gross = 'GROSS',
  Junkfood = 'JUNKFOOD',
  Meat = 'MEAT',
  Nuts = 'NUTS',
  Pineapple = 'PINEAPPLE',
  Raw = 'RAW',
  Seafood = 'SEAFOOD',
  Sugar = 'SUGAR',
  Toxic = 'TOXIC',
  Vegetables = 'VEGETABLES',
}

export enum JobPriority {
  Low = 1,
  Medium = 2,
  High = 3,
}

export type Name = {
  can_randomize: BooleanLike;
  explanation: string;
  group: string;
};

export type Species = {
  desc: string[];
  diet?: {
    disliked_food: Food[];
    liked_food: Food[];
    toxic_food: Food[];
  };
  enabled_features: string[];
  icon: string;

  lore: string[];
  name: string;

  sexes: BooleanLike;

  traits: {
    negative: Trait[];
    neutral: Trait[];
    positive: Trait[];
  };

  use_skintones: BooleanLike;
};

export type Trait = {
  description: string;
  icon: string;
  name: string;
};

export type Department = {
  color: string;
  css_class: string;
  head?: string;
  name: string;
};

export type Job = {
  alt_titles: string[];
  css_class: string;
  department: string;
  description: string[];
  flavor: string[];
  sub_department?: string;
  tips: string[];
};

export type Quirk = {
  description: string;
  icon: string;
  name: string;
  value: number;
};

export type QuirkInfo = {
  max_positive_quirks: number;
  quirk_blacklist: string[][];
  quirk_info: Record<string, Quirk>;
};

export enum RandomSetting {
  AntagOnly = 1,
  Disabled = 2,
  Enabled = 3,
}

export enum JoblessRole {
  BeOverflow = 1,
  BeRandomJob = 2,
  ReturnToLobby = 3,
}

export enum GamePreferencesSelectedPage {
  Settings,
  Keybindings,
}

export const createSetPreference =
  (act: typeof sendAct, preference: string) => (value: unknown) => {
    act('set_preference', {
      preference,
      value,
    });
  };

export enum Window {
  Character = 0,
  Game = 1,
  Keybindings = 2,
}

export type CharacterProfile = {
  // Base64
  image: string | null;
  name: string | null;
};

export type PreferencesMenuData = {
  active_slot: number;
  antag_bans?: string[];
  antag_days_left?: Record<string, number>;

  character_preferences: {
    clothing: Record<string, string>;
    features: Record<string, string>;
    game_preferences: Record<string, unknown>;
    misc: {
      gender: Gender;
      job_priority: Record<string, JobPriority>;
      joblessrole: JoblessRole;
      species: string;
    };
    non_contextual: {
      [otherKey: string]: unknown;
      random_body: RandomSetting;
    };
    pii: Record<string, unknown>;
    randomization: Record<string, RandomSetting>;
    secondary_features: Record<string, unknown>;
    supplemental_features: Record<string, unknown>;
  };

  character_preview_view: string;

  character_profiles: CharacterProfile[];

  content_unlocked: BooleanLike;

  jobs: Record<
    string,
    {
      account_days_left: number;
      banned?: string;
      playtime_required: {
        department: string;
        time_left: number; // in minutes
      };
    }
  >;

  keybindings: Record<string, string[]>;
  name_to_use: string;

  overflow_role: string;
  preview_options: string;
  preview_selection: string;

  selected_antags: string[];
  selected_quirks: string[];

  window: Window;
};

export type PreferenceData = {
  [otherKey: string]: unknown;
  feature: string;
  locked?: BooleanLike;
  name?: string;
};

export type ServerData = {
  [otherKey: string]: PreferenceData;
  jobs: PreferenceData & {
    departments: Record<string, Department>;
    jobs: Record<string, Job>;
  };
  names: PreferenceData & {
    types: Record<string, Name>;
  };
  quirks: PreferenceData & QuirkInfo;
  random: PreferenceData & {
    randomizable: string[];
  };
  species: PreferenceData & Record<string, Species>;
  species_previews: PreferenceData &
    Record<
      string,
      {
        female: [string, string, string, string];
        male: [string, string, string, string];
      }
    >;
};
