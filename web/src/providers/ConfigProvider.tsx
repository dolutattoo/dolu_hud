import { Context, createContext, useContext, useState } from 'react'
import { useNuiEvent } from '../hooks/useNuiEvent'

interface Config {
  debug: boolean|number
  speedo: boolean
  hideRadarOnFoot: boolean
  speedoMetrics: string
  seatbeltKey: string
  setMaxHealth: boolean
  colors: {
    health: string
    armour: string
    voice: string
    oxygen: string
    speedo: string
    hunger: string
    thirst: string
    stress: string
    drunk: string
  }
}

interface ConfigContextValue {
  config: Config
  setConfig: (config: Config) => void
}

const ConfigCtx = createContext<ConfigContextValue | null>(null)

const ConfigProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [config, setConfig] = useState<Config>({
    "debug": false,
    "speedo": true,
    "hideRadarOnFoot": true,
    "speedoMetrics": "kmh",
    "seatbeltKey": "K",
    "setMaxHealth": true,
    "colors": {
      "health": "teal.4",
      "armour": "blue.5",
      "voice": "gray.2",
      "oxygen": "cyan",
      "speedo": "teal",
      "hunger": "yellow",
      "thirst": "cyan.5",
      "stress": "orange",
      "drunk": "grape"
    }
  })

  useNuiEvent('setConfig', async (data: Config) => setConfig(data))

  return <ConfigCtx.Provider value={{ config, setConfig }}>{children}</ConfigCtx.Provider>
}

export default ConfigProvider

export const useConfig = () => useContext<ConfigContextValue>(ConfigCtx as Context<ConfigContextValue>)
