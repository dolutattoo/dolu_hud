import React, { useState } from 'React'
import { Box, Center, Group, RingProgress, Text, ThemeIcon } from '@mantine/core'
import { useNuiEvent } from '../hooks/useNuiEvent'
import { Progress } from 'react-sweet-progress'
import "react-sweet-progress/lib/style.css"
import Config from '../../../config.json'

const Speedo: React.FC = () => {
  // Visibility
  const [visible, setVisible] = useState<boolean>(false)
  useNuiEvent('toggleSpeedo', (state: boolean) => setVisible(state))

  // ProgressBars states values
  const [speed, setSpeed] = useState<number>(0)
  const [gear, setGear] = useState<number>(0)
  const [rpm, setRpm] = useState<number>(0)

  // Set values from client script
  useNuiEvent('setSpeedo', (data: {speed: number, gear:number , rpm: number}) => {
    setSpeed(data.speed)
    setGear(data.gear)
    setRpm((data.rpm*100)/1)
  })

  const getRpmColor = (value: number) => {
    if (value < 30) {
      return 'teal'
    } else if (value < 50) {
      return 'blue'
    } else if (value < 75) {
      return 'yellow'
    } else if (value < 95) {
      return 'orange'
    } else {
      return 'red'
    }
  }

  return (
    <>
        {visible &&
          <>

            <Progress
              style={{ transform: 'rotate(-90deg)', position: 'fixed', bottom: '1vh' }}
              type="circle"
              percent={50}
              status="active"
              width="8vw"
              strokeWidth={7}
              theme={{
                default: {
                  color: 'rgba(0, 0, 0, 0.7)',
                  trailColor: 'rgba(0, 0, 0, 0)'
                },
                active: {
                  color: 'rgba(0, 0, 0, 0.7)',
                  trailColor: 'rgba(0, 0, 0, 0)'
                }
              }}
            />

            <Progress
              style={{ transform: 'rotate(-90deg)', position: 'absolute', bottom: '1vh' }}
              type="circle"
              percent={(rpm)/2}
              status="active"
              width="8vw"
              strokeWidth={7}
              theme={{
                default: {
                  color: getRpmColor(rpm),
                  trailColor: 'rgba(0, 0, 0, 0)'
                },
                active: {
                  color: getRpmColor(rpm),
                  trailColor: 'rgba(0, 0, 0, 0)'
                }
              }}
            />

            <Center>
              <Box
                style={{ bottom: '7vh', width: '5vw', position: 'fixed', marginTop: '-10vh', backgroundColor: 'rgba(0, 0, 0, 0.7)', borderRadius: '0.7vh', justifyContent: 'center' }}
              >
                <Center>
                  <Group spacing={1}>
                    <Text
                      color='gray.4'
                      size='md'
                      weight={600}
                    >
                      {speed}
                    </Text>
                    <Text
                      color='gray.4'
                      size='xs'
                      weight={400}
                    >
                      { Config.speedoMetrics === 'kmh' ? 'Km/h' : 'mph' }
                    </Text>
                  </Group>
                </Center>
              </Box>
            </Center>
          </>
        }
    </>
  )
}

export default Speedo