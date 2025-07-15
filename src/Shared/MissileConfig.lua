local Config = {}

-- Nombre del modelo del misil en ReplicatedStorage
Config.MissileModelName = "Missile"

-- Posicion inicial de lanzamiento
Config.LaunchPosition = Vector3.new(0, 10, 0)

-- Velocidad inicial al despegar
Config.InitialSpeed = 100

-- Velocidad de crucero durante el seguimiento del objetivo
Config.CruiseSpeed = 150

-- Fuerza maxima aplicada al misil
Config.MaxForce = 5000

-- Sensibilidad para que el misil gire hacia el objetivo
Config.OrientationResponsiveness = 200

-- Tiempo en segundos antes de autodestruirse si no alcanza el objetivo
Config.AutoDestructTime = 30

-- Radio de la explosion
Config.ExplosionRadius = 15

-- Nombre de la GUI que contiene el script del cliente
Config.TargetingGUIName = "MissileTargetingGui"

-- Objetos del workspace que no se muestran en la lista de objetivos
Config.ExcludedObjects = {
    ["Baseplate"] = true,
}

return Config
