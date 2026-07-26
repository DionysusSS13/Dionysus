import { useBackend, useLocalState } from '../../backend';
import { Box, Icon } from '../../components';
import { CharacterProfile, PreferencesMenuData } from './data';
import { DioPrefsPage } from './Pages';

export const CharacterSelect = (props) => {
  const { data } = useBackend<PreferencesMenuData>();

  let index = 0;
  return (
    <Box className="DioPrefs__CharacterSelect__Container">
      {data.character_profiles.map((char) => {
        index++;
        return <CharacterEntry char={char} index={index} key={index} />;
      })}
    </Box>
  );
};

const CharacterEntry = (props: { char: CharacterProfile; index: number }) => {
  const { act } = useBackend<PreferencesMenuData>();
  const [_, setPage] = useLocalState('DioPrefs_page', DioPrefsPage.SELECT);

  return (
    <Box
      className="DioPrefs__CharacterSelect__Entry"
      onClick={() => {
        act('change_slot', { slot: props.index });
        setPage(DioPrefsPage.APPEARANCE);
      }}
      inline
    >
      {props.char.image ? (
        <img
          className="Portrait"
          src={'data:image/png;base64, ' + props.char.image}
        />
      ) : (
        <Icon className="Portrait" name="question" />
      )}

      <div className="Text">
        {splitStringEvenlyOverTwoLines(
          props.char.name || 'Create New Character',
        ).map((s) => (
          <div key={s}>{s}</div>
        ))}
      </div>
    </Box>
  );
};

const splitStringEvenlyOverTwoLines = (text: string) => {
  let middle = Math.floor(text.length / 2);
  const spaceBefore = text.lastIndexOf(' ', middle);
  const spaceAfter = text.indexOf(' ', middle + 1);

  if (
    spaceBefore === -1 ||
    (spaceAfter !== -1 && middle - spaceBefore >= spaceAfter - middle)
  ) {
    middle = spaceAfter;
  } else {
    middle = spaceBefore;
  }

  return [text.substring(0, middle), text.substring(middle + 1)];
};
