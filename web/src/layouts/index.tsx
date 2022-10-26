import React, { useState } from 'React'
import { Center, Group, RingProgress, ThemeIcon } from '@mantine/core'
import { BiBrain, BiHeart, BiMicrophone, BiShield } from 'react-icons/bi'
import { TbDroplet, TbGlass, TbLungs, TbMeat } from 'react-icons/tb'
import { FiRadio } from 'react-icons/fi'
import { useNuiEvent } from '../hooks/useNuiEvent'
import { fetchNui } from '../utils/fetchNui'
import Speedo from './Speedo'
import config from '../../../config.json'

interface StatusProps {
  voiceLevel: number
  health: number
  armour: number
  hunger: number
  thirst: number
  stress: number
  oxygen: number
  drunk: number
}

const Hud: React.FC = () => {
  const [visible, setVisible] = useState<boolean>(false)
  const [isTalkingRadio, setTalkingRadio] = useState<number>(0)
  const [voiceLevel, setVoiceLevel] = useState<number>(0)
  const [health, setHealth] = useState<number>(0)
  const [healthColor, setHealthColor] = useState<string>('teal')
  const [armour, setArmour] = useState<number>(0)
  const [hunger, setHunger] = useState<number>(config.status.hunger.default)
  const [hungerColor, setHungerColor] = useState<string>('yellow')
  const [thirst, setThirst] = useState<number>(config.status.thirst.default)
  const [thirstColor, setThirstColor] = useState<string>('blue')
  const [stress, setStress] = useState<number>(config.status.stress.default)
  const [drunk, setDrunk] = useState<number>(config.status.drunk.default)
  const [oxygen, setOxygen] = useState<number>(100)

  useNuiEvent('toggleVisibility', (value: boolean) => setVisible(value))

  useNuiEvent('init', (data: StatusProps) => {
    setVoiceLevel(data.voiceLevel*33.3333)
    setHealth(data.health)
    setArmour(data.armour)
    setHunger(data.hunger)
    setThirst(data.thirst)
    setStress(data.stress)
    setDrunk(data.drunk)
    fetchNui('nuiReady')
    setVisible(true)
  })

  useNuiEvent('setStatusValue', (data: { statusName: string, value: number }) => {
    if (data.statusName === 'voiceLevel') {
      setVoiceLevel(data.value*33.3333)
    } else if (data.statusName === 'health') {
      setHealth(data.value)
      setHealthColor(getColor(data.value, 'teal'))
    } else if (data.statusName === 'armour') {
      setArmour(data.value)
    } else if (data.statusName === 'hunger') {
      setHunger(data.value)
      setHungerColor(getColor(data.value, 'yellow'))
    } else if (data.statusName === 'thirst') {
      setThirst(data.value)
      setThirstColor(getColor(data.value, 'blue'))
    } else if (data.statusName === 'stress') {
      setStress(data.value)
    } else if (data.statusName === 'drunk') {
      setDrunk(data.value)
    } else if (data.statusName === 'oxygen') {
      setOxygen(data.value)
      setHealthColor(getColor(data.value, 'cyan'))
    } else if (data.statusName === 'radioState') {
      setTalkingRadio(data.value)
    }
  })

  const getColor = (value: number, color:string) => {
    if (value > 10) { return color } else { return 'red' }
  }

  return (
    <>
        {visible && <Group spacing={0} style={{ position: 'absolute', bottom: '0' }}>

          {/* SPEEDO */}
          {config.speedo && <Speedo />}

          {/* VOICE */}
          {voiceLevel > 0 && <RingProgress sections={[{ value: voiceLevel, color: 'gray.2' }]} thickness={6} size={55} roundCaps
            label={
              <Center>
                <ThemeIcon color='gray.2' variant='light' radius='xl' size={44}>
                  {isTalkingRadio > 0 ? <FiRadio size={23} /> : <BiMicrophone size={23} /> }
                </ThemeIcon>
              </Center>
            }
          />}

          {/* HEALTH */}
          {health !== undefined && <RingProgress sections={[{ value: health, color: healthColor }]} thickness={6} size={55} roundCaps
            label={
              <Center>
                <ThemeIcon color={healthColor} variant='light' radius='xl' size={44}>
                  <BiHeart size={23} />
                </ThemeIcon>
              </Center>
            }
          />}

          {/* ARMOR */}
          {armour > 0 && <RingProgress sections={[{ value: armour, color: 'blue' }]} thickness={6} size={55} roundCaps
            label={
              <Center>
                <ThemeIcon color='blue' variant='light' radius='xl' size={44}>
                  <BiShield size={23} />
                </ThemeIcon>
              </Center>
            }
          />}

          {/* HUNGER */}
          {(config.status.hunger.hideOnFull ? hunger < 100 : true) &&
            <RingProgress sections={[{ value: hunger, color: hungerColor }]} thickness={6} size={55} roundCaps
              label={
                <Center>
                  <ThemeIcon color={hungerColor} variant='light' radius='xl' size={44}>
                    <TbMeat size={23} />
                  </ThemeIcon>
                </Center>
              }
            />
          }

          {/* THIRST */}
          {(config.status.thirst.hideOnFull ? thirst < 100 : true) &&
            <RingProgress sections={[{ value: thirst, color: thirstColor }]} thickness={6} size={55} roundCaps
              label={
                <Center>
                  <ThemeIcon color={thirstColor} variant='light' radius='xl' size={44}>
                    <TbDroplet size={23} />
                  </ThemeIcon>
                </Center>
              }
            />
          }

          {/* STRESS */}
          {(config.status.stress.hideOnFull ? stress > 0 : true) &&
            <RingProgress sections={[{ value: stress, color: 'orange' }]} thickness={6} size={55} roundCaps
              label={
                <Center>
                  <ThemeIcon color='orange' variant='light' radius='xl' size={44}>
                    <BiBrain size={23} />
                  </ThemeIcon>
                </Center>
              }
            />
          }

          {/* DRUNK */}
          {(config.status.drunk.hideOnFull ? drunk > 0 : true) &&
            <RingProgress sections={[{ value: drunk, color: 'grape' }]} thickness={6} size={55} roundCaps
              label={
                <Center>
                  <ThemeIcon color='grape' variant='light' radius='xl' size={44}>
                    <TbGlass size={23} />
                  </ThemeIcon>
                </Center>
              }
            />
          }

          {/* OXYGEN */}
          {oxygen < 100 && <RingProgress sections={[{ value: oxygen, color: 'cyan' }]} thickness={6} size={55} roundCaps
            label={
              <Center>
                <ThemeIcon color='cyan' variant='light' radius='xl' size={44}>
                  <TbLungs size={23} />
                </ThemeIcon>
              </Center>
            }
          />}

        </Group>}
    </>
  )
}

export default Hud