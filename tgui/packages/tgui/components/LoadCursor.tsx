/*
 Stolen and heavily tweaked Bootstra.386 load cursor

 To any react nerd reading this, I'm not sorry. Pick a better language next time. - Rimi
*/

import { ReactNode, useEffect, useRef, useState } from 'react';

import { Box, computeBoxProps } from './Box';

type Config = {
  fastLoad?: boolean;
  onePass?: boolean;
  speedFactor?: number;
};

type State = {
  alreadyRan: boolean;
  barBottom: string;
  barWidth: string;
  cursorBottom: string;
  cursorRight: string;
  hideCursor: boolean;
  hideWrap: boolean;
  wrapHeight: string;
};

export const LoadCursor: React.FC<{
  [otherKey: string]: any;
  children: ReactNode;
  config?: Config;
}> = ({ children, config = {}, ...rest }) => {
  const childRef = useRef<HTMLDivElement>(null);
  let interval;
  const [state, setState] = useState<State>({
    barWidth: '',
    hideCursor: true,
    cursorBottom: '',
    cursorRight: '',
    wrapHeight: '',
    alreadyRan: false,
    barBottom: '',
    hideWrap: false,
    ...rest,
  });

  useEffect(() => {
    if (config.fastLoad || !children || state.alreadyRan) {
      return;
    }

    setState({ ...state, alreadyRan: true });

    const onePass = config.onePass;
    const speedFactor = (1 / (config.speedFactor || 2)) * 165000;
    const rect = childRef.current?.getBoundingClientRect();
    if (!rect) return;
    const height = rect.height;
    const width = rect.width;

    const character = { height: 20, width: 12.4 };
    let rounds = (height * width) / speedFactor;
    let column = width;
    let row = height - character.height;
    let pass = 0;

    interval = setInterval(() => {
      console.log('ran');
      for (let m = 0; m < rounds; m++) {
        column -= character.width;
        if (column <= 0) {
          column = width;
          row -= character.height;
        }
        if (row <= 0) {
          pass++;
          row = height - character.height;
          if (pass === 2 || onePass) {
            clearInterval(interval);
          } else {
            rounds /= 2;
            character.height *= 4;
          }
        }

        if (pass === 0) {
          state.barBottom = row + 'px';
          state.barWidth = column + 'px';
          state.wrapHeight = row + 'px';
        } else {
          state.cursorRight = column + 'px';
          state.cursorBottom = row + 'px';
        }
        if (m === rounds) {
          state.hideCursor = true;
        }
        setState({ ...state });
      }

      if (pass === 1) {
        state.hideWrap = true;
        state.hideCursor = false;
      }
      if (pass === 2 || onePass) {
        state.hideWrap = true;
        state.hideCursor = true;
      }

      setState({ ...state });
    }, 1);
  }, []);

  return (
    <div {...computeBoxProps(rest)} className="loadCursor" ref={childRef}>
      {children}
      <Box
        style={{
          visibility: state.hideWrap ? 'hidden' : 'visible',
          height: state.wrapHeight,
        }}
        className="LoadCursor__wrapper"
      />
      <Box
        style={{
          visibility: state.hideWrap ? 'hidden' : 'visible',
          width: state.barWidth,
          bottom: state.barBottom,
        }}
        className="LoadCursor__bar"
      >
        <Box className="LoadCursor__scancursor" />
      </Box>
      <Box
        style={{
          visibility: state.hideCursor ? 'hidden' : 'visible',
          right: state.cursorRight,
          bottom: state.cursorBottom,
        }}
        className="LoadCursor__rescancursor"
      />
    </div>
  );
};

export default LoadCursor;
