import { ImageAddon } from '@xterm/addon-image';
import { Terminal } from '@xterm/xterm';
import { useEffect, useRef } from 'react';
import { useBackend } from '../backend';
import { Window } from '../layouts';

import '@xterm/xterm/css/xterm.css';

type TerminalInterface = {
  id: string;
  isLocal: boolean;
  port: number;
  url: string;
};
export const SCTerminalInterface = (props) => {
  const { act, data } = useBackend<TerminalInterface>();
  const cref = useRef<HTMLDivElement>(null);
  const ws = new WebSocket(`ws://${data.url}:${data.port}/tty`);
  const term = new Terminal({
    cols: 80,
    rows: 25,
  });
  const imgAddon = new ImageAddon({});
  term.loadAddon(imgAddon);
  let opened = false;
  const queued: Array<any> = [];
  ws.onopen = (ev) => {
    ws.send(`\x00${data.id}`);
  };

  ws.onmessage = (msg) => {
    msg.data.bytes().then((bytes) => {
      if (opened) term.write(bytes);
      else queued.push(bytes);
    });
  };

  ws.onclose = () => {
    if (opened) term.write('NO CARRIER');
  };

  term.onData((data) => {
    ws.send(`\x01${data}`);
  });

  useEffect(() => {
    term.open(cref.current!);
    opened = true;
    queued.forEach((v) => {
      term.write(v);
    });
  }, []);

  let timer;

  const PowerPress = () => {};
  const PowerRelease = () => {};

  return (
    <Window>
      <Window.Content>
        <div ref={cref} />
      </Window.Content>
    </Window>
  );
};
