import { exhaustiveCheck } from 'common/exhaustive';

import { useBackend } from '../../backend';
import { CharacterPreferencesWindow } from './CharacterPreferencesWindow';
import {
  GamePreferencesSelectedPage,
  PreferencesMenuData,
  Window,
} from './data';
import { GamePreferenceWindow } from './GamePreferencesWindow';

export const DioPrefs = (props) => {
  const { data } = useBackend<PreferencesMenuData>();

  switch (data.window) {
    case Window.Character:
      return <CharacterPreferencesWindow />;
    case Window.Game:
      return <GamePreferenceWindow />;
    case Window.Keybindings:
      return (
        <GamePreferenceWindow
          startingPage={GamePreferencesSelectedPage.Keybindings}
        />
      );
    default:
      exhaustiveCheck(data.window);
  }
};
