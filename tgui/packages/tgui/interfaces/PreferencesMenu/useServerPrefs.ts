import { createContext, useContext } from 'react';

import { ServerData } from './types';

export const ServerPrefs = createContext<ServerData | undefined>({
  jobs: {
    departments: {},
    jobs: {},
  },
  names: {
    types: {},
  },
  quirks: {
    max_positive_quirks: -1,
    quirk_info: {},
    quirk_blacklist: [],
    points_enabled: false,
  },
  random: {
    randomizable: [],
  },
  loadout: {
    loadout_tabs: [],
    max_loadouts: 0,
  },
  species: {},
});

export function useServerPrefs() {
  return useContext(ServerPrefs);
}
