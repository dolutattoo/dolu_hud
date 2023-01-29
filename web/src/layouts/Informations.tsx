import React, { useState } from 'react'
import { Text } from '@mantine/core'
import { useNuiEvent } from '../hooks/useNuiEvent'

interface Informations {
  playerId?: number
}

const Information: React.FC = () => {
    const [playerId, setPlayerId] = useState<number>(0)
    const [dateString, setDateString] = useState('')

    // Refresh Date every seconds
    setInterval(() => {
      const date = new Date()
      const dateString = ('0' + date.getHours()).slice(-2) + ":" + ('0' + date.getMinutes()).slice(-2) + " " + ('0' + date.getDate()).slice(-2) + "/" + ('0' + (date.getMonth()+1)).slice(-2)
      setDateString(dateString)
    }, 1000)

    // Set values from client script
    useNuiEvent('setStatuses', (data: Informations) => {
      if (data.playerId !== undefined) setPlayerId(data.playerId)
    })

    return (
      <Text style={{
        "width": "auto",
        "height": "15px",
        "fontWeight": "400",
        "fontSize": "12px",
        "lineHeight": "15px",
        "color": "#FFFFFF",
        "position": "absolute",
        "top": "1px",
        "right": "1px",
      }}>
        ID:{playerId} {dateString}
      </Text>
    )
}

export default Information