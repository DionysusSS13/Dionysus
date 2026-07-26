import { Dispatch, SetStateAction, useState } from 'react';

import { useBackend } from '../backend';
import { PreferencesMenuData } from '../interfaces/DioPrefs/data';
import { Box } from './Box';
import { Button } from './Button';
import { Image } from './Image';

export type Rect = {
  height: number;
  width: number;
  x: number;
  y: number;
};

export type Part = {
  id:
    | 'head'
    | 'left_arm'
    | 'right_arm'
    | 'groin'
    | 'torso'
    | 'left_leg'
    | 'right_leg';
  name: string;
  onSet?: (oldPart: Part | null) => {};
  onUnset?: (newPart: Part) => {};
  pos: Rect;
};

export const CharacterDoll = (props: {
  center?: number;
  dollSize: number;
  iconSize?: number;
  parts: Part[];
  selectedPart: Part | null;
  setSelectedPart: Dispatch<SetStateAction<Part | null>>;
}) => {
  const {
    dollSize,
    parts,
    iconSize = 32,
    center = dollSize / 2,
    selectedPart,
    setSelectedPart,
  } = props;
  const { data } = useBackend<PreferencesMenuData>();
  const [lastOrigin, setLastOrigin] = useState<null | string>(null);

  const pixelMultiplier = dollSize / iconSize;

  return (
    <Box
      className="DioPrefs__CharacterDoll"
      width={`${dollSize}px`}
      height={`${dollSize}px`}
      position="relative"
    >
      <Box
        // Click catcher
        onClick={() => setSelectedPart(null)}
        width="100%"
        height="100%"
        position="absolute"
      />
      <Box
        className="DioPrefs__CharacterDoll__ImageContainer"
        style={{
          transformOrigin: lastOrigin || '',
          transform: props.selectedPart ? 'scale(2)' : 'scale(1)',
        }}
      >
        {!selectedPart &&
          parts.map((part) => {
            return (
              <CharacterPart
                part={part}
                pixelMultiplier={pixelMultiplier}
                dollSize={dollSize}
                center={center}
                key={part.id}
                setSelectedPart={setSelectedPart}
                selectedPart={selectedPart}
                setLastOrigin={setLastOrigin}
              />
            );
          })}
        <Image
          className="DioPrefs__CharacterDoll__ImageContainer__Image"
          onClick={() => setSelectedPart(null)}
          src={`data:image/png;base64, ${data.character_profiles[0].image}`}
        />
      </Box>
    </Box>
  );
};

const CharacterPart = (props: {
  center: number;
  dollSize: number;
  part: Part;
  pixelMultiplier: number;
  selectedPart;
  setLastOrigin;
  setSelectedPart;
}) => {
  const { data } = useBackend<PreferencesMenuData>();
  const {
    part,
    pixelMultiplier,
    dollSize,
    center,
    selectedPart,
    setSelectedPart,
    setLastOrigin,
  } = props;

  const scale = (n: number) => {
    return n * pixelMultiplier;
  };

  return (
    <Button
      width={`${scale(part.pos.width)}px`}
      height={`${scale(part.pos.height)}px`}
      position="absolute"
      left={`calc(${scale(part.pos.x)}px - ${scale(part.pos.width / 2)}px)`}
      top={`calc(${scale(part.pos.y)}px - ${scale(part.pos.height / 2)}px)`}
      onClick={() => {
        const oldPart = selectedPart;
        selectedPart?.onUnset && selectedPart.onUnset(part);
        setSelectedPart(part);
        selectedPart?.onSet && selectedPart.onSet(oldPart);
        // This is so fucking lazy, but it works and looks clean enough
        setLastOrigin(
          `${scale(part.pos.x - 0.5 + (-center + part.pos.x) * 0.8)}px ${scale(part.pos.y + (-center + part.pos.y) * 0.8)}px`,
        );
      }}
      style={{
        maskImage: `url('data:image/png;base64, ${data.character_profiles[0].image}')`,
        maskRepeat: 'no-repeat',
        maskSize: `${dollSize}px`,
        maskPosition: `calc(${scale(part.pos.x)}px - ${scale(part.pos.width / 2)}px) calc(${scale(part.pos.y)}px - ${scale(part.pos.height / 2)}px)`,
      }}
    />
  );
};
