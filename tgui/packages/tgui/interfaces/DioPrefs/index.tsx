import { Button } from 'tgui-core/components';

import { useBackend, useLocalState } from '../../backend';
import { Box, Stack } from '../../components';
import { Window } from '../../layouts';
import { AppearancePage } from './AppearancePage';
import { CharacterPreview } from './CharacterPreview';
import { CharacterSelect } from './CharacterSelectPage';
import { PreferencesMenuData } from './data';
import { JobsPage } from './JobsPage';
import { LorePage } from './LorePage';
import { OOCPage } from './OOCPage';
import { DioPrefsPage, HIDDEN_PAGES } from './Pages';
import { SpeciesPage } from './SpeciesPage';

export const DioPrefs = (props) => {
  const { act, data } = useBackend<PreferencesMenuData>();
  const [currentPage, setCurrentPage] = useLocalState(
    'DioPrefs_page',
    DioPrefsPage.SELECT,
  );

  let page;

  switch (currentPage) {
    case DioPrefsPage.SELECT:
      page = <CharacterSelect />;
      break;
    case DioPrefsPage.APPEARANCE:
      page = <AppearancePage />;
      break;
    case DioPrefsPage.SPECIES:
      page = <SpeciesPage />;
      break;
    case DioPrefsPage.JOBS:
      page = <JobsPage />;
      break;
    case DioPrefsPage.LORE:
      page = <LorePage />;
      break;
    case DioPrefsPage.OOC:
      page = <OOCPage />;
      break;
    default:
      page = <CharacterSelect />;
      break;
  }

  return (
    <Window
      title={currentPage}
      theme="dionysus"
      width={1100}
      height={770}
      onMount={() => act('do_da_jiggle')}
    >
      <Stack fill>
        <Stack.Item width="100%">
          <Stack vertical fill>
            <Stack.Item>
              <Stack vertical width="100%">
                <Stack.Item
                  style={{ display: 'flex', justifyContent: 'center' }}
                >
                  <Button selected>Character</Button>
                  <Button>Game</Button>
                </Stack.Item>
                <Stack.Divider />
                <Stack.Item
                  style={{ display: 'flex', justifyContent: 'center' }}
                >
                  <h3>{data.character_preferences.pii.real_name}</h3>
                </Stack.Item>
                <Stack.Item
                  style={{ display: 'flex', justifyContent: 'center' }}
                >
                  {Object.entries(DioPrefsPage).map(([key, value]) => {
                    if (HIDDEN_PAGES.includes(value)) {
                      return;
                    }
                    return (
                      <Button
                        key={key}
                        selected={value === currentPage}
                        onClick={() => setCurrentPage(value)}
                      >
                        {value}
                      </Button>
                    );
                  })}
                </Stack.Item>
                <Stack.Divider />
              </Stack>
            </Stack.Item>
            <Stack.Item height="100%">
              <Box position="relative" width="100%" height="100%">
                <Stack fill>
                  <Stack.Item width="100%">{page}</Stack.Item>
                </Stack>
              </Box>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Divider />
        <Stack.Item style={{ width: '158px' }}>
          <CharacterPreview id={data.character_preview_view} />
        </Stack.Item>
      </Stack>
    </Window>
  );
};
