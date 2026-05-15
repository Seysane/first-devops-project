DORA - DevOps Research and Assessment

DORA Metrics are four key performance indicators used to measure the 
effectivness of DevOps teams.

1. Deployment Frequency (DF) - The frequency at witch an organization 
successfully releases to production.

Goal: To measure how often the organization successfully releases
code to production or delivers it to end-users.

Importance: It indicates the team's agility and the maturity of
their automation. Frequent, small deployments reduce risk and allow
for faster feedback loops.


2. Lead Time for Changes (LT) - The amount of time it takes a code
change to get from "code commited" to "code running in production".

Goal: To measure the time it takes for a single commit to go from
being written to running successfully in production.

Importance: This reflects the efficiency of the CI/CD pipeline.
A shorter lead time means the team can respond quickly to market
changes or urgent bug fixes.


3. Change Failure Rate (CFR) - The percentage of deployments causing
a failure in production that requires a hotfix or rollback.

Goal: To measure the percentage of deployments that result in a 
failure (service outage, degraded performance) and require a rollback
or hotfix.

Importance: It serves as a quality gate. High speed is useless if it leads to unstable systems, this metric ensures that velocity
does not compromise stability.


4. Mean Time to Recovery (MTTR) - The average time it takes to
restore service after a failure occurs in production.

Goal: To measure the average time it takes to restore service after
an incident or failure occurs in the production environment.

Importance: In a DevOps culture, failures are expected. MTTR shows
how well the team is prepared to diagnose and fix problems, 
minimizing downtime for the user.
