import { useState } from 'react';
import { Button } from 'tgui-core/components';

import { useBackend, useLocalState } from '../../backend';
import { Box, ByondUi, Stack } from '../../components';
import { PreferencesMenuData } from './data';
import { DioPrefsPage } from './Pages';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

const CHARACTER_PORTRAIT_SIZE = 160;

export const CharacterPreview = (props) => {
  const { data, act } = useBackend<PreferencesMenuData>();
  const [current_page] = useLocalState('DioPrefs_page', DioPrefsPage.SELECT);

  const [previewSpecies, setPreviewSpecies] = useLocalState(
    'DioPrefs_previewSpecies',
    data.character_preferences.misc.species || 'human',
  );

  const [previewSex, setPreviewSex] = useState('male');

  const [previewIndex, setPreviewIndex] = useState(0);

  return (
    <Stack vertical height="100%" pt="5px" pb="5px">
      <Stack.Item>
        {current_page !== DioPrefsPage.SPECIES ? (
          <Stack vertical>
            <Stack.Item style={{ justifyContent: 'center', display: 'flex' }}>
              <Button>Job</Button>
              <Button>Loadout</Button>
            </Stack.Item>
            <Stack.Item
              mt="0"
              style={{ justifyContent: 'center', display: 'flex' }}
            >
              <Button>Underwear</Button>
              <Button>Naked</Button>
            </Stack.Item>
          </Stack>
        ) : (
          <Stack vertical>
            <Stack.Item style={{ justifyContent: 'center', display: 'flex' }}>
              <Button onClick={() => setPreviewIndex(0)}>1</Button>
              <Button onClick={() => setPreviewIndex(1)}>2</Button>
              <Button onClick={() => setPreviewIndex(2)}>3</Button>
              <Button onClick={() => setPreviewIndex(3)}>4</Button>
            </Stack.Item>
            <Stack.Item
              mt="0"
              style={{ justifyContent: 'center', display: 'flex' }}
            >
              <Button onClick={() => setPreviewSex('male')}>Male</Button>
              <Button onClick={() => setPreviewSex('female')}>Female</Button>
            </Stack.Item>
          </Stack>
        )}
      </Stack.Item>
      <Stack.Item height="100%" width="220px">
        <ServerPreferencesFetcher
          render={(serverData) =>
            current_page === DioPrefsPage.SPECIES ? (
              <Stack vertical>
                <SpeciesPreview
                  previewSpecies={previewSpecies}
                  previewIndex={previewIndex}
                  previewSex={previewSex}
                  dir="south"
                />
                <SpeciesPreview
                  previewSpecies={previewSpecies}
                  previewIndex={previewIndex}
                  previewSex={previewSex}
                  dir="north"
                />
                <SpeciesPreview
                  previewSpecies={previewSpecies}
                  previewIndex={previewIndex}
                  previewSex={previewSex}
                  dir="east"
                />
                <SpeciesPreview
                  previewSpecies={previewSpecies}
                  previewIndex={previewIndex}
                  previewSex={previewSex}
                  dir="west"
                />
              </Stack>
            ) : (
              <Box>
                <ByondUi
                  width={`${CHARACTER_PORTRAIT_SIZE}px`}
                  height={`${CHARACTER_PORTRAIT_SIZE}px`}
                  params={{ id: data.character_preview_view[0], type: 'map' }}
                />
                <ByondUi
                  width={`${CHARACTER_PORTRAIT_SIZE}px`}
                  height={`${CHARACTER_PORTRAIT_SIZE}px`}
                  params={{ id: data.character_preview_view[1], type: 'map' }}
                />
                <ByondUi
                  width={`${CHARACTER_PORTRAIT_SIZE}px`}
                  height={`${CHARACTER_PORTRAIT_SIZE}px`}
                  params={{ id: data.character_preview_view[2], type: 'map' }}
                />
                <ByondUi
                  width={`${CHARACTER_PORTRAIT_SIZE}px`}
                  height={`${CHARACTER_PORTRAIT_SIZE}px`}
                  params={{ id: data.character_preview_view[3], type: 'map' }}
                />
              </Box>
            )
          }
        />
      </Stack.Item>
      <Stack.Item align="center" width="100%" basis="0" height="100px">
        <Button
          icon="arrow-left"
          ml="2px"
          onClick={() => act('cycle_background')}
        />
        <Box inline align="center" width="107px">
          Background
        </Box>
        <Button
          icon="arrow-right"
          onClick={() => act('cycle_background', { forwards: true })}
        />
      </Stack.Item>
    </Stack>
  );
};

const SpeciesPreview = (props) => {
  return (
    <Stack.Item
      position="relative"
      width={`${CHARACTER_PORTRAIT_SIZE}px`}
      height={`${CHARACTER_PORTRAIT_SIZE}px`}
      mt="0"
    >
      <Box
        className={`preferences32x32 species___${props.previewSpecies}_${props.previewSex}_${props.previewIndex + 1}_${props.dir}`}
        style={{
          scale: `${CHARACTER_PORTRAIT_SIZE / 32}`,
          imageRendering: 'pixelated',
        }}
        position="absolute"
        left={`${(CHARACTER_PORTRAIT_SIZE / 32 - (CHARACTER_PORTRAIT_SIZE / 32 - 2)) * 32}px`}
        top={`${(CHARACTER_PORTRAIT_SIZE / 32 - (CHARACTER_PORTRAIT_SIZE / 32 - 2)) * 32}px`}
      />
    </Stack.Item>
  );
};
