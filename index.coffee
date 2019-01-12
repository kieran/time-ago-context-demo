import React        from "react"
import { render }   from "react-dom"

# I do love me some date-fns
import distanceInWordsStrict from 'date-fns/distance_in_words_strict'

# make it more message-y
import './styles'


# this creates the context we'll be eavesdropping on
NowContext = React.createContext new Date()

# just used for the fake message data, ignore this
fakeSentAt = new Date

class Conversation extends React.Component
  # seed with fake messages
  render: ->
    <div className="Conversation">
      {for i in [1..5]
        <Message
          key={i}
          sent={fakeSentAt}
          text={"this is message #{i}"}
        />
      }
    </div>

class Message extends React.Component
  # consumes the value for `now` from the context API
  #
  # this will cause a re-render whenever the value changes
  render: ->
    <NowContext.Consumer>
      {(now)=>

        <div className="Message">
          {@props.text}
          <div className="when">
            {distanceInWordsStrict @props.sent, now} ago
          </div>
        </div>

      }
    </NowContext.Consumer>


#
# Main App holds the single interval,
# updates the context & re-renders
#
class App extends React.Component
  constructor: ->
    super arguments...
    @state =
      now: new Date

  #
  # updates the app every second
  #
  tick: =>
    console.log 'tick!'
    @setState now: new Date

  componentDidMount: =>
    @interval = setInterval @tick, 1000

  componentWillUnmount: =>
    clearInterval @interval


  # make the provider available to the whole app tree
  render: ->
    <NowContext.Provider value={@state.now}>
      <Conversation/>
    </NowContext.Provider>

render <App />, document.getElementById "Application"
