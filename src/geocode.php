<?php

require __DIR__ . '/vendor/autoload.php';

$f = fopen('./training_city_stats.csv', 'r');

$adapter  = new \Ivory\HttpAdapter\CurlHttpAdapter();
$geocoder = new \Geocoder\Provider\OpenStreetMap($adapter);

$getProperties = function ($address, $data) {
    $properties = array_filter($address->toArray(), function ($value) {
        return !empty($value);
    });
    unset(
        $properties['latitude'],
        $properties['longitude'],
        $properties['bounds']
    );

    $properties['# workshops held'] = $data[1];

    return $properties;
};

$getFeature = function ($address, $data) use ($getProperties) {
    return [
        'type' => 'Feature',
        'geometry' => [
            'type'        => 'Point',
            'coordinates' => [ $address->getLongitude(), $address->getLatitude() ]
        ],
        'properties' => $getProperties($address, $data),
    ];
};

$features = [];
while (false !== $data = fgetcsv($f, 0, "\t")) {
    try {
        $address = $geocoder->geocode($data[0])->first();
    } catch (\Exception $e) {
        echo 'Error, skipping: ' . $data[0] . ' (' . $e->getMessage() . ')';
        continue;
    }

    $features[] = $getFeature($address, $data);
}

fclose($f);

echo json_encode([
    'type'     => 'FeatureCollection',
    'features' => $features,
]);
