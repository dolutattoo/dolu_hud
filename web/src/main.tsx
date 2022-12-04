import { MantineProvider } from '@mantine/core'
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App'
import './index.css'
import ConfigProvider from './providers/ConfigProvider'
import { isEnvBrowser } from './utils/misc'

if (isEnvBrowser()) {
  const root = document.getElementById('root')

  // https://i.imgur.com/iPTAdYV.png - Night time img
  root!.style.backgroundImage = 'url("https://i.imgur.com/3pzRj9n.png")'
  root!.style.backgroundSize = 'cover'
  root!.style.backgroundRepeat = 'no-repeat'
  root!.style.backgroundPosition = 'center'
}

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ConfigProvider>
      <MantineProvider theme={{ colorScheme: 'dark' }}>
        <App />
      </MantineProvider>
    </ConfigProvider>
  </React.StrictMode>
)
