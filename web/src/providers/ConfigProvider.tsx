import React, { Context, createContext, useContext, useState } from "react"
import { useNuiEvent } from "../hooks/useNuiEvent"

interface Status {
  default: number
  onTick: {
    action: string
    value: number
  }
}

export interface Config {
  debug: boolean
  hideRadarOnFoot: boolean
  updateInterval: number
  updateDatabaseInterval: number
  status: {
    hunger: Status
    thirst: Status
    stress: Status
    drunk: Status
  }
}

interface ConfigContextValue {
  config: Config
  setConfig: (config: Config) => void
}

const ConfigCtx = createContext<ConfigContextValue | null>(null)

const ConfigProvider: React.FC<{children: React.ReactNode}> = ({children}) => {
  const [config, setConfig] = useState<Config>({
    debug: false,
    hideRadarOnFoot: true,
    updateInterval: 2500,
    updateDatabaseInterval: 60000,
    status: {
      hunger: {
        default: 100,
        onTick: {
          action: 'remove',
          value: 0.1
        }
      },
      thirst: {
        default: 100,
        onTick: {
          action: 'remove',
          value: 0.1
        }
      },
      stress: {
        default: 0,
        onTick: {
          action: 'remove',
          value: 0.1
        }
      },
      drunk: {
        default: 0,
        onTick: {
          action: 'remove',
          value: 0.1
        }
      }
    }
  })

  useNuiEvent('setConfig', async (data: Config) => setConfig(data))

  return <ConfigCtx.Provider value={{ config, setConfig }}>{children}</ConfigCtx.Provider>
}

export default ConfigProvider

export const useConfig = () => useContext<ConfigContextValue>(ConfigCtx as Context<ConfigContextValue>)
