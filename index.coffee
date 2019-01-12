import React        from "react"
import ReactDOM     from "react-dom"

# I do love me some date-fns
import distanceInWordsStrict  from 'date-fns/distance_in_words_strict'
import subSeconds             from 'date-fns/sub_seconds'

# make it more message-y
import './styles'


#
# this creates the context we'll be eavesdropping on
#
NowContext = React.createContext new Date()


#
# Main App holds the single interval,
# updates the context & re-renders
#
class App extends React.Component
  constructor: ->
    super arguments...
    @state =
      now: new Date()

  #
  # updates the app every second
  #
  tick: =>
    console.log 'tick!'
    @setState now: new Date()

  componentDidMount: =>
    @interval = setInterval @tick, 1000

  componentWillUnmount: =>
    clearInterval @interval


  #
  # make the provider available to the whole app tree
  #
  render: ->
    <NowContext.Provider value={@state.now}>
      <Conversation/>
    </NowContext.Provider>


# just used for faking message data, ignore this
fakeSentAt = new Date()

class Conversation extends React.Component
  # seed with fake messages
  render: ->
    <div className="Conversation">
      {for i in [1..1000]
        <Message
          key={i}
          sent={subSeconds fakeSentAt, i*5}
          text={"this is message #{i}"}
        />
      }
    </div>


class Message extends React.Component
  render: ->
    <div className="Message">
      {@props.text}
      <TimeAgo since={@props.sent}/>
    </div>


class TimeAgo extends React.Component
  # consumes the value for `now` from the context
  #
  # this will cause a re-render whenever the `now` changes
  # but will only do the expensive DOM update if the
  # time string is different
  render: ->
    <div className="TimeAgo">
      <NowContext.Consumer>
        {(now)=>
          "#{distanceInWordsStrict @props.since, now} ago"
        }
      </NowContext.Consumer>
    </div>


ReactDOM.render <App />, document.getElementById 'Application'
