import React, { useState } from 'react'
import { useNuiEvent } from '../hooks/useNuiEvent'
import { useConfig } from "../providers/ConfigProvider";
import { fetchNui } from '../utils/fetchNui'
import { Box, Center, Text } from '@mantine/core'

interface Informations {
	toggle?: boolean
  config?: any
    playerID?: number
}

const Information: React.FC = () => {
    // Config
    const { config } = useConfig()

    // Visibility
    const [visible, setVisible] = useState<boolean>(false)

    // Variables
    const [playerID, setPlayerID] = useState<number>(0)
    const [dateString, setDateString] = useState('');

    //Set Date every minute
    setInterval(() => {
        const date = new Date();
        const dateString = ('0' + date.getHours()).slice(-2) + ":" + ('0' + date.getMinutes()).slice(-2) + " - " + ('0' + date.getDate()).slice(-2) + "/" + ('0' + (date.getMonth()+1)).slice(-2) + "/" + date.getFullYear();
        setDateString(dateString)
        }, 1000)
    
    // Set values from client script
    useNuiEvent('setStatuses', (data: Informations) => {
        if (data.toggle !== undefined) {
            setVisible(data.toggle)
            if (data.toggle === true) {
                fetchNui('nuiReady')
            }
        }
        if (data.playerID !== undefined) {
            /* setPlayerID(9999) */
            setPlayerID(data.playerID)
        }
    })

    return (
        <>
        {visible &&
            <Text style={
                {
                    "width": "auto",
                    "height": "15px",
                    "fontWeight": "400",
                    "fontSize": "12px",
                    "lineHeight": "15px",
                    "color": "#FFFFFF",
                    "position": "absolute",
                    "bottom": "0px",
                    "left": "0px",
                  }
            }>
                ID: {playerID} - {dateString}
            </Text>
        }
        </>
    )
}

export default Information