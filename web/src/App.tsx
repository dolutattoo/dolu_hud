import { Box, createStyles } from '@mantine/core'
import Hud from './layouts/Hud'
import Speedo from './layouts/Speedo'
import Information from './layouts/Informations'
import config from '../../config.json'

const useStyles = createStyles((theme) => ({
  status: {
    width: '100%',
    height: '100%',
    display: 'flex',
    justifyContent: 'center'
  },
  speedo: {
    width: '100%',
    height: '100%',
    display: 'flex',
    justifyContent: 'left',
    marginLeft: '17vw'
  }
}))

const App: React.FC = () => {
  const { classes } = useStyles()

  return (
    <>
      {config.topScreenInfo && <Information />}
      <Box className={classes.status}>
        <Hud />
        <Speedo />
      </Box>
    </>
  )
}

export default App
