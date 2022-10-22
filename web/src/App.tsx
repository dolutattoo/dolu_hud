import { Box, createStyles } from '@mantine/core'
import Hud from './layouts'

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

  return (
    <>
      <Box className={classes.container}>
        <Hud />
      </Box>
    </>
  )
}

export default App
