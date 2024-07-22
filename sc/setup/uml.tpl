@startuml {{ .InitCtl }}

[*] --> DemoState: [ CheckAlwaysTrue ]
[*] -[bold]-> [*]: / Print(The guard needs to be implemented)

DemoState: do / AddMsg(Hello)
DemoState: do / AddMsg(World)
DemoState: do / AddMsg(!)
DemoState --> BurnState: [ CheckAlwaysTrue ] / Print(Go to BurnState)
DemoState -[bold]-> [*]


BurnState: do / Print(Got messages)
BurnState: do / PrintMsgs
BurnState -[bold]-> [*]