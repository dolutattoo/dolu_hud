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

    // Date
    setInterval(() => {
      const date = new Date();
      const dateString = ('0' + date.getHours()).slice(-2) + ":" + ('0' + date.getMinutes()).slice(-2) + " - " + ('0' + date.getDate()).slice(-2) + "/" + ('0' + (date.getMonth()+1)).slice(-2) + "/" + date.getFullYear();
      setDateString(dateString)
    }, 60000)


    // Visibility
    const [visible, setVisible] = useState<boolean>(false)
    useNuiEvent('toggleVisibility', (state: boolean) => setVisible(state))

    // Variables
    const [playerID, setPlayerID] = useState<number>(0)
    
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
        {visible && <>
        <Box style={
            {
                "display": "flex",
                "flexDirection": "column",
                "justifyContent": "center",
                "alignItems": "center",
                "padding": "0px",
                "position": "absolute",
                "bottom": "0px",
                "right": "0px",
                "width": "110px",
                "height": "30px",
                "background": "rgba(0, 0, 0, 0.5)"
            }
        }>
            <Text style={
                {
                    "width": "110px",
                    "height": "15px",
                    "fontWeight": "400",
                    "fontSize": "12px",
                    "lineHeight": "15px",
                    "textAlign": "center",
                    "color": "#FFFFFF",
                    "flex": "none",
                    "order": "0",
                    "flexGrow": "0"
                  }
            }>
                {playerID}
            </Text>
            <Text style={
                {
                    "width": "110px",
                    "height": "15px",
                    "fontWeight": "400",
                    "fontSize": "12px",
                    "lineHeight": "15px",
                    "textAlign": "center",
                    "color": "#FFFFFF",
                    "flex": "none",
                    "order": "1",
                    "flexGrow": "0"
                  }
            }>
                {dateString}
            </Text>
        </Box>
        
        </>}
        </>
    )
}

export default Information