import { useBackend, useLocalState } from '../../backend';
import { Box, Button, Section, Stack } from '../../components';
import { PreferencesMenuData } from './data';
import { RecordEditorModal } from './LorePage';
import { AllFeaturesInCategory } from './PreferenceTypes';
import { ServerPreferencesFetcher } from './ServerPreferencesFetcher';

export const OOCPage = (props) => {
  const { data, act } = useBackend<PreferencesMenuData>();
  const [editing, setEditing] = useLocalState<string | null>(
    'ooc_editing',
    null,
  );

  return (
    <ServerPreferencesFetcher
      render={(serverData) => {
        if (!serverData) {
          return;
        }

        return (
          <Stack fill vertical>
            <Stack.Item width="100%">
              <Stack fill>
                <Stack.Item width="100%">
                  <Section title="OOC Information" fill scrollable>
                    <Box style={{ display: 'flex', justifyContent: 'center' }}>
                      <Button
                        big
                        onClick={() => setEditing('general_inspection_text')}
                      >
                        Edit General Inspection Text
                      </Button>
                    </Box>
                    <AllFeaturesInCategory category="ooc" />
                  </Section>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            {editing && (
              <RecordEditorModal
                prefId={editing}
                serverData={serverData}
                onClose={() => {
                  setEditing(null);
                }}
                onSubmit={(text) => {
                  act('set_preference', {
                    preference: editing,
                    value: text,
                  });
                  setEditing(null);
                }}
              />
            )}
          </Stack>
        );
      }}
    />
  );
};
