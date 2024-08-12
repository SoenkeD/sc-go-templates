@startuml {{ .InitCtl }}

[*] --> Demoing: [ CheckAlwaysTrue ]
[*] -[bold]-> [*]: / Print(The guard needs to be implemented)

Demoing: do / AddMsg(Hello)
Demoing: do / AddMsg(World)
Demoing: do / AddMsg(!)
Demoing --> Burning: [ CheckAlwaysTrue ] / Print(Go to Burning)
Demoing -[bold]-> [*]


Burning: do / Print(Got messages)
Burning: do / PrintMsgs
Burning -[bold]-> [*]