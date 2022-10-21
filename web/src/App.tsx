import { Box, createStyles } from '@mantine/core'
import Hud from './layouts'
import { useConfig } from './providers/ConfigProvider'

const useStyles = createStyles((theme) => ({
  container: {
    width: '100%',
    height: '100%',
    display: 'flex',
    justifyContent: 'center'
  }
}))

const App: React.FC = () => {
  const { classes } = useStyles()
  const { config } = useConfig()

  console.log(JSON.stringify(config, null, '\t'))


  return (
    <>
      <Box className={classes.container}>
        <Hud />
      </Box>
    </>
  )
}

export default App
